from PyQt5 import QtWidgets, uic
from pathlib import Path
import importlib
import logging
import os
import subprocess
import sys
if __name__ == "__main__":
    sys.path.append("..") # let you import from directory above when running this file directly
    from appupdator import AppUpdator
else:
    from ..appupdator import AppUpdator

try: 
    logger 
except: 
    logger = logging.getLogger(__name__)

def resource_path(relative_path):
    """ Get absolute path to resource, works for dev and for PyInstaller """
    path = Path(__file__).parent / relative_path
    return str(path)

app_layout = resource_path(r"..\layouts\layout_generic.ui")
Ui_MainWindow, QtBaseClass = uic.loadUiType(app_layout)
class Launcher(QtWidgets.QMainWindow, Ui_MainWindow):

    def __init__(self, toolname="", vertical_label="G E N E R I C", note=None, 
            app_download_url="", download_name="", download_directory="", 
            host_type="sharepoint_onedrive", zipped_exe_name="", 
            execute_from_app_directory=True, warning_note = None,
            new_shell=False, new_console=False):
        super().__init__()
        Ui_MainWindow.__init__(self)
        self.setupUi(self)
        self.verticalLabel.setText(vertical_label)
        self.toolname = toolname
        self.buttonOpenScript.setText(f"Launch {self.toolname}")
        self.setWindowTitle(self.toolname)
        self.label.setText(f"{note if note else 'Note: May take 1-2 minutes to launch when running for the first time (check console for status)'}")
        if warning_note:
            self.warningLabel.setText(warning_note)
        #App Logic
        self.buttonOpenScript.clicked.connect(self.open_script)
        self.Applauncher = AppUpdator(
            self.toolname, 
            app_download_url=app_download_url,
            download_name=download_name,
            download_directory=download_directory,
            host=host_type,
            zipped_exe_name=zipped_exe_name,
            execute_from_app_directory=execute_from_app_directory,
            )
        self.new_shell = new_shell
        self.new_console = new_console


    def open_script(self):
        try:
            print(f"Calling {self.toolname} using generic launcher, generic ui")
            self.Applauncher.update_app()
            self.Applauncher.run_app(close_after_running_app=False, new_shell=self.new_shell, new_console=self.new_console)
        except ModuleNotFoundError as e:
            logger.exception(e)
            self.trigger_exception(f"ModuleNotFoundError launching {self.toolname}, ping Harry Collins or Idriss Animashaun")
        except Exception as e:
            logger.exception(e)
            self.trigger_exception(f"Unknown error launching {self.toolname}, ping Harry Collins or Idriss Animashaun")


    def trigger_exception(self, message):
        print(message)
        QtWidgets.QMessageBox.about(self, "Exception", message)


if __name__ == '__main__':
    print(__file__)
    print(os.path.abspath(__file__))
    print(os.path.dirname(os.path.abspath(__file__)))
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    app = QtWidgets.QApplication(sys.argv)
    ex = PlopLauncher()
    ex.show()
    sys.exit(app.exec_())
