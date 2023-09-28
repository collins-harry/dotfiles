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
class ThermalTools(QtWidgets.QMainWindow, Ui_MainWindow):

    def __init__(self):
        super().__init__()
        Ui_MainWindow.__init__(self)
        self.setupUi(self)

        self.tab1 = Launcher(
            "PCSpuller", 
            vertical_label = "P C S P U L L E R",
            app_download_url="Documents/special/pcspuller/pcspuller.zip",
            download_name="pcspuller.zip",
            download_directory = "downloaded_tools/pcspuller",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "pcspuller.exe",
            # warning_note = "AQUA V3 -> V4 conversion may affect this Tool. Please ping Harry Collins if there is unexpected behaviour",
            )
        self.tabs.addTab(self.tab1,"PCSpuller")

        self.tab2 = Launcher(
            "DTSmonitor",
            vertical_label = "D T S M O N I T O R",
            app_download_url="Documents/special/dtsmonitor/dtsmonitor.zip",
            download_name="dtsmonitor.zip",
            download_directory = "downloaded_tools/dtsmonitor",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "dtsmonitor.exe",
            # warning_note = "AQUA V3 -> V4 conversion may affect this Tool. Please ping Harry Collins if there is unexpected behaviour",
            )
        self.tabs.addTab(self.tab2,"DTSmonitor")

        self.tab3 = Launcher(
            "SORTprocessingscript",
            vertical_label = "S O R T S C R I P T",
            app_download_url="Documents/special/sortprocessingscript/SORTprocessingscript.jsl",
            download_name="SORTprocessingscript.jsl",
            download_directory = "downloaded_tools/sortprocessingscript",
            host_type = "sharepoint_onedrive",
            # zipped_exe_name = "dtsmonitor.exe"
            )
        self.tabs.addTab(self.tab3,"SORTprocessingscript")

        self.tab4 = Launcher(
            "Manifestation",
            vertical_label = "M A N I F E S T",
            app_download_url="Documents/special/Manifestation/main.exe",
            download_name="main.exe",
            download_directory = "downloaded_tools/manifestation",
            host_type = "sharepoint_onedrive",
            # zipped_exe_name = "main/main.exe"
            )
        self.tabs.addTab(self.tab4,"Manifestation")

        self.tab5 = Launcher(
            "DataStreamer",
            vertical_label = "D A T A S T R E A M",
            app_download_url="Documents/special/datastreamer/datastreamer.zip",
            download_name="datastreamer.zip",
            download_directory = "downloaded_tools/datastreamer",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "main/main.exe"
            )
        self.tabs.addTab(self.tab5,"DataStreamPlotter")
        self.tabs.setCurrentIndex(0)   


