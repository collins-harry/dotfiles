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
class TPModificationTools(QtWidgets.QMainWindow, Ui_MainWindow):

    def __init__(self):
        super().__init__()
        Ui_MainWindow.__init__(self)
        self.setupUi(self)

        self.tab1 = Launcher(
            "EmptyPaella", 
            vertical_label = "P A E L L A E D I T",
            app_download_url="Documents/special/emptypaella/empty-paella-updates.zip",
            download_name="empty-paella-updates.zip",
            download_directory = "downloaded_tools/emptypaella",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "main/main.exe",
            execute_from_app_directory=False,
            )
        self.tabs.addTab(self.tab1,"EmptyPaella")

        self.tab2 = Launcher(
            "IMP", 
            vertical_label = "I D V G E N",
            app_download_url="Documents/special/imp/Release.zip",
            download_name="Release.zip",
            download_directory = "downloaded_tools/imp",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "IDV_XML_PRISM_test.exe",
            execute_from_app_directory=True,
            )
        self.tabs.addTab(self.tab2,"IMP(IDV)")

        self.tab3 = Launcher(
            "Need4Seed",
            vertical_label = "N E E D 4 S E E D",
            app_download_url="Documents/special/need4seed/main.exe",
            download_name="main.exe",
            download_directory = "downloaded_tools/need4seed",
            host_type = "sharepoint_onedrive",
            # zipped_exe_name = "main/main.exe"
            )
        self.tabs.addTab(self.tab3,"Need4Seed")


        # self.tab1 = ShmooHarvesterLauncher()
        # self.tabs.addTab(self.tab1,"ShmooHarvester")
        self.tabs.setCurrentIndex(0)   


