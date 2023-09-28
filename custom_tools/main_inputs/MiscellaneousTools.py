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
class MiscellaneousTools(QtWidgets.QMainWindow, Ui_MainWindow):

    def __init__(self):
        super().__init__()
        Ui_MainWindow.__init__(self)
        self.setupUi(self)

        self.tab1 = Launcher(
            "Foldercopier",
            vertical_label = "F O L D E R C O P Y",
            app_download_url="Documents/special/foldercopier/foldercopierlauncher.zip",
            download_name="foldercopierlauncher.zip",
            download_directory = "downloaded_tools/foldercopier",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "foldercopierlauncher.exe"
            )
        self.tabs.addTab(self.tab1,"Foldercopier")

        self.tabs.setCurrentIndex(0)   


