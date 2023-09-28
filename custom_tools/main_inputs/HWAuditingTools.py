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
class HWAuditingTools(QtWidgets.QMainWindow, Ui_MainWindow):

    def __init__(self):
        super().__init__()
        Ui_MainWindow.__init__(self)
        self.setupUi(self)

        self.tab0 = Launcher(
            "SIUHealthTracker",
            vertical_label = "S I U H E A L T H",
            app_download_url="Documents/special/siu_health_tracker/main.exe",
            download_name="main.exe",
            download_directory = "downloaded_tools/siu_health_tracker",
            host_type = "sharepoint_onedrive",
            # zipped_exe_name = "main/main.exe",
            # warning_note = "AQUA V3 -> V4 conversion may affect this Tool. Please ping Idriss Animashaun if there is unexpected behaviour",
            )
        self.tabs.addTab(self.tab0,"SIUHealthTracker")

        self.tab1 = Launcher(
            "Touchdown",
            vertical_label = "T O U C H D O W N",
            app_download_url="Documents/special/touchdown/touchdown.zip",
            download_name="touchdown.zip",
            download_directory = "downloaded_tools/touchdown",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "main/main.exe"
            )
        self.tabs.addTab(self.tab1,"Touchdown")

        self.tabs.setCurrentIndex(0)   


