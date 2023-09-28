import ctypes  # An included library with Python install.   
import logging
import os 
import re
import shutil
import sys
import time
import urllib.request
from office365.runtime.auth.client_credential import ClientCredential
from office365.sharepoint.client_context import ClientContext
from pathlib import Path
from subprocess import Popen, CREATE_NEW_CONSOLE
from zipfile import ZipFile

try: 
    logger 
except: 
    logger = logging.getLogger(__name__)

class AppUpdator():
    """Application launcher that checks for updates to the main app, updates if necessary"""
    def __init__(self, launcher_name: str, app_download_url :str="", download_name: str="", download_directory: str=None, host: str="gitlab", zipped_exe_name="main.exe", execute_from_app_directory=True):
        self.launcher_name = launcher_name
        self.lowercase_launcher_name = self.launcher_name.lower()
        self.app_download_url = app_download_url
        self.download_directory = Path(download_directory)
        self.execute_from_app_directory=execute_from_app_directory
        self.host = host
        if host.lower() == "sharepoint_onedrive":
            self.client_id = ""
            self.client_secret = ""
            self.site_url = ""
            self.app_download_url = "" + self.app_download_url
        elif host.lower() == "sharepoint_site":
            self.client_id = ""
            self.client_secret = ""
            self.site_url = ""
            # self.app_download_url = "" + self.app_download_url
            self.app_download_url = "/"+self.app_download_url
        self.isDownloadZipped = True if app_download_url[-4:] == ".zip" else False
        if self.isDownloadZipped and download_directory:
            self.download_file_path = self.download_directory / download_name
            self.app_path = self.download_directory / download_name[:-4] / zipped_exe_name
            self.extractfolder = self.download_file_path.with_name(self.download_file_path.stem)
        elif self.isDownloadZipped:
            self._trigger_exception(f'Error, download path should be specified if isDownloadZipped is True, Ping Harry Collins')
            sys.exit(1)
        elif download_directory:
            self.download_file_path = self.download_directory / download_name
            self.app_path = self.download_directory / download_name
        else:
            self.download_file_path = Path(download_name)
            self.app_path = Path(download_name)

    def update_app(self):
        """Is application already installed? If yes get file size to compare for upgrade"""
        print(f"*** Checking for updates for {self.launcher_name}***")
        if self._should_i_update():
            print("*** Found updates ***")
            success = self._delete_old_app()
            if success == False: return False
            self._download_app()
        else:
            print("*** No updates needed ***")

    def run_app(self, close_after_running_app=False, new_shell=False, new_console=True):
        """We open the real application"""
        try:
            print(fr"*** Starting {self.app_path} ***")
            if self.app_path.suffix == ".jsl":
                print("File is jsl file")
                os.system(str(self.app_path))
            elif new_console and self.execute_from_app_directory:
                print("self.app_path: ", self.app_path)
                Popen(self.app_path, creationflags=CREATE_NEW_CONSOLE, cwd=os.path.dirname(self.app_path))
            elif new_shell:
                Popen(f"start {self.app_path}", shell=True)
            elif self.execute_from_app_directory:
                Popen(self.app_path, cwd=os.path.dirname(self.app_path))
            else:
                # Popen(self.app_path, cwd=os.path.dirname(self.app_path))
                Popen(self.app_path)
            print(f"current working directory for Toolshed: {os.getcwd()}")
            print(f"*** Opening {self.launcher_name} ***")
            time.sleep(2)
            if close_after_running_app:
                print("*** Closing this console window ***")
                sys.exit(0)
        except Exception as e:
            print(e)
            self._trigger_exception(f'Failed to open application, Please try open the file manually: {self.app_path}, otherwise ping Harry Collins')
            sys.exit(1)
    
    def _should_i_update(self):
        """Checks if the app is already installed and if there is an update available"""
        try:
            if self.host.lower() == "gitlab":
                self.url_file = urllib.request.urlopen(self.app_download_url) # points to the exe file for size
            elif self.host.lower() in ["sharepoint_onedrive", "sharepoint_site"]:
                ctx = ClientContext(self.site_url).with_credentials(ClientCredential(self.client_id, self.client_secret))
                print(f"{self.site_url=}")
                print(f"{self.app_download_url=}")
                self.url_file = ctx.web.get_file_by_server_relative_path(self.app_download_url)
                ctx.load(self.url_file).execute_query()
                print("sharepoint file: ", self.url_file)
        except urllib.error.URLError as e:
            logger.exception(e)
            print(f"Error Reason: {e.reason}")
            if self.host.lower() == "gitlab":
                self._trigger_exception(f"URLError: Could not access the gitlab link to {self.launcher_name}. Are you on the VPN? Can you access goto/{self.lowercase_launcher_name}app? Otherwise ping Harry Collins")
            else:
                self._trigger_exception(f"URLError: Could not access the link to {self.launcher_name}. Are you on the VPN? Otherwise ping Harry Collins")
            sys.exit(1)
        except Exception as e:
            logger.exception(e)
            print(f"Error Reason: {e}")
            self._trigger_exception("Exception: Unknown Exception, ping Harry Collins")
            sys.exit(1)
        if self.host.lower() == "gitlab":
            web_file_size = int(self.url_file.info()["Content-Length"])
        else:
            web_file_size = int(self.url_file.get_property("Length"))
        ### Check if application already installed
        if os.path.isfile(self.app_path) and os.path.isfile(self.download_file_path):
            local_file_size = int(os.path.getsize(self.download_file_path))
            if local_file_size != web_file_size:# upgrade available
                print("*** New upgrade available! ***")
                return True
            else: return False
        ### Application wasn't installed, so we download and install it here                
        else:
            return True

    def _download_app(self):
        if self.download_directory:
            print(f"*** Confirming/creating application directory: {self.download_directory} ***")
            Path(self.download_directory).mkdir(parents=True, exist_ok=True)
        self._download_update()
        if self.isDownloadZipped:
            self._unzip_downloaded_app()
        time.sleep(0.1)

    def _download_update(self):
        print("*** Downloading updates ***")
        try:
            if self.host.lower() == "gitlab":
                # urllib.request.urlretrieve(self.app_download_url, self.download_file_path, _show_progress)
                urllib.request.urlretrieve(self.app_download_url, self.download_file_path)
            else:
                with open(self.download_file_path, "wb") as output_file:
                    self.url_file.download(output_file).execute_query()
        except PermissionError as e:
            logger.exception(e)
            self._trigger_exception("Permission Error, Cannot update EXE due to being unable to delete the old exe, do you have the app open in another window? Otherwise ping Harry Collins")
            sys.exit(1)
        print("*** Downloaded updates ***")

    def _unzip_downloaded_app(self):
        print("*** Download is a zip file, unzipping ***")
        self.extractfolder = self.download_file_path.with_name(self.download_file_path.stem)
        # self.app_name 

        zip_name = self.download_file_path.stem
        

        with ZipFile(self.download_file_path, "r") as zip_ref:
            if zip_ref.namelist()[0][:len(zip_name)] == zip_name:
                zip_ref.extractall(self.download_directory)
            else:
                zip_ref.extractall(str(self.download_file_path)[:-4])

        print("*** Finished Unzipping ***")

    def _trigger_exception(self, message, title="EXCEPTION", uType=0):
        print(message)
        uTypes = {
                0: 0,
                "MB_ICONEXCLAMATION": 0x30,
                "MB_ICONWARNING": 0x30,
                "MB_ICONINFORMATION": 0x40,
                "MB_ICONASTERISK": 0x40,
                "MB_ICONQUESTION": 0x20,
                "MB_ICONSTOP": 0x10,
                "MB_ICONERROR": 0x10,
                "MB_ICONHAND": 0x10,
                }
        ctypes.windll.user32.MessageBoxW(0, message, title, uTypes[uType])

    def _delete_old_app(self):    
        print("*** Removing old files ***")
        try: 
            if os.path.isfile(self.download_file_path):
                os.remove(self.download_file_path)
            if self.isDownloadZipped and self.extractfolder.is_dir():
                shutil.rmtree(self.extractfolder)
            print("**** Removed old files ****")
        except PermissionError as e:
            logger.exception(e)
            self._trigger_exception("Permission Error, could not delete old executable, do you have it open in another window? Otherwise ping Harry Collins")
            return False

            

    # def _show_progress(self, block_num, block_size, total_size):
    #     pbar = progressbar.ProgressBar(maxval=total_size)
    #     pbar.start()
    #     downloaded = block_num * block_size
    #     if downloaded < total_size:
    #         pbar.update(downloaded)
    #     else:
    #         pbar.finish()
    #         pbar = None


if __name__ == '__main__':
    if re.search("python.exe", sys.executable):
        print(__file__)
        print(os.path.abspath(__file__))
        print(os.path.dirname(os.path.abspath(__file__)))
        os.chdir(os.path.dirname(os.path.abspath(__file__)))
    else:
        print(sys.executable)
        print(os.path.abspath(sys.executable))
        print(os.path.dirname(os.path.abspath(sys.executable)))
        os.chdir(os.path.dirname(os.path.abspath(sys.executable)))
    main()
