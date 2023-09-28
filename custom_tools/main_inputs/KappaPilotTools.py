import sys
from pathlib import Path
from PyQt5 import QtWidgets, uic
from PyQt5.QtGui import QIcon
from PyQt5.QtCore import pyqtSlot
from main_inputs.launchers.generic_launcher import Launcher

def resource_path(relative_path):
    """ Get absolute path to resource, works for dev and for PyInstaller """
    path = Path(__file__).parent / relative_path
    return str(path)

app_layout = resource_path(r"layouts\layout_nonThermalTools.ui")
Ui_MainWindow, QtBaseClass = uic.loadUiType(app_layout)
class KappaPilotTools(QtWidgets.QMainWindow, Ui_MainWindow):

    def __init__(self):
        super().__init__()
        Ui_MainWindow.__init__(self)
        self.setupUi(self)
        self.tab1 = Launcher(
            "TPITracker", 
            vertical_label = "T P I T R A C K E R",
            app_download_url="Documents/special/tpi_tracker/py-tpi-tracker-exe-updates.zip",
            download_name="py-tpi-tracker-exe-updates.zip",
            download_directory = "downloaded_tools/tpi_tracker",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "main/main.exe",
            execute_from_app_directory=False,
            )
        self.tabs.addTab(self.tab1,"TPITracker")

        self.tab2 = Launcher(
            "DFF_KAT", 
            vertical_label = "D F F K A T",
            app_download_url="Documents/special/dff_kat/dff-kat-updates.zip",
            download_name="dff-kat-updates.zip",
            download_directory = "downloaded_tools/dff_kat",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "main/main.exe"
            )
        self.tabs.addTab(self.tab2,"DFFKAT")

        self.tab3 = Launcher(
            "DataWatchDog", 
            vertical_label = "W A T C H D O G",
            app_download_url="Documents/special/datawatchdog/datawatchdog.zip",
            download_name="datawatchdog.zip",
            download_directory = "downloaded_tools/datawatchdog",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "datawatchdog.exe"
            )
        self.tabs.addTab(self.tab3,"DataWatchDog")
        self.tabs.setCurrentIndex(0)   


