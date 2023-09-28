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
class TPAuditTools(QtWidgets.QMainWindow, Ui_MainWindow):

    def __init__(self):
        super().__init__()
        Ui_MainWindow.__init__(self)
        self.setupUi(self)

        self.tab1 = Launcher(
            "Waterfallpuller", 
            vertical_label = "W A T E R F A L L",
            app_download_url="Documents/special/waterfallpuller/main.zip",
            download_name="main.zip",
            download_directory = "downloaded_tools/waterfallpuller",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "main.exe"
            )
        self.tabs.addTab(self.tab1,"Waterfallpuller")

        self.tab2 = Launcher(
            "Whose Got ADTL?", 
            vertical_label = "A D T L",
            app_download_url="Documents/special/Whose_Got_ADTL/main.zip",
            download_name="main.zip",
            download_directory = "downloaded_tools/Whose_Got_ADTL",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "main.exe"
            )
        self.tabs.addTab(self.tab2,"whose_got_ADTL?")
        
        self.tab3 = Launcher(
            "CPD_UF!CALL check", 
            vertical_label = "C P D C A L L",
            app_download_url="Documents/special/CPD_UF_CALL_audit/main.zip",
            download_name="main.zip",
            download_directory = "downloaded_tools/cpd_uf_call_audit",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "main.exe"
            )
        self.tabs.addTab(self.tab3,"CPD_UF!Call_Check")

        self.tab4 = Launcher(
            "Post_Evasion", 
            vertical_label = "P O S T E V A D E",
            app_download_url="Documents/special/post_evasion/main.zip",
            download_name="main.zip",
            download_directory = "downloaded_tools/post_evasion",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "main.exe"
            )
        self.tabs.addTab(self.tab4,"Post Evasion")

        self.tabs.setCurrentIndex(0)   


