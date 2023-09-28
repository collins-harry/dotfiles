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
class DataAnalysisTools(QtWidgets.QMainWindow, Ui_MainWindow):

    def __init__(self):
        super().__init__()
        Ui_MainWindow.__init__(self)
        self.setupUi(self)

        self.tab1 = Launcher(
            "Plop", 
            vertical_label = "P L O P",
            app_download_url="Documents/special/plop/Plop.zip",
            download_name="Plop.zip",
            download_directory = "downloaded_tools/plop",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "Plop.exe"
            )
        self.tabs.addTab(self.tab1,"Plop")

        self.tab2 = Launcher(
            "Data Analysis Toolkit", 
            vertical_label = "D A T A A N A L",
            app_download_url="Documents/special/data_analysis_toolkit/main.zip",
            download_name="main.zip",
            download_directory = "downloaded_tools/data_analysis_toolkit",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "main.exe"
            )
        self.tabs.addTab(self.tab2,"Data Analysis Toolkit")

        self.tab3 = Launcher(
            "ShowTTime", 
            vertical_label = "S H O W T T I M E",
            app_download_url="Documents/special/showttime/TestCostPull.zip",
            download_name="TestCostPull.zip",
            download_directory = "downloaded_tools/TestCostPull",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "TestCostPullMain/TestCostPullMain/bin/Debug/TestCostPullMain.exe",
            new_console=True
            )
        self.tabs.addTab(self.tab3,"ShowTTime")
        
        self.tab4 = Launcher(
            "GetAppRate", 
            vertical_label = "A P P R A T E",
            app_download_url="Documents/special/getapprate/GetAppRate.zip",
            download_name="GetAppRate.zip",
            download_directory = "downloaded_tools/GetAppRate",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "GetAppRate.exe",
            )
        self.tabs.addTab(self.tab4,"GetAppRate")

        self.tab5 = Launcher(
            "TCSit", 
            vertical_label = "T C S E T U P",
            app_download_url="Documents/special/tcsit/Release.zip",
            download_name="Release.zip",
            download_directory = "downloaded_tools/tcsit",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "TCSIT_trial.exe",
            execute_from_app_directory=True,
            )
        self.tabs.addTab(self.tab5,"TCSit")

        self.tab6 = Launcher(
            "SliceTrackGeni",
            vertical_label = "S L I C E G E N I",
            app_download_url="Documents/special/slicetrackgeni/slicetrackgeni.zip",
            download_name="slicetrackgeni.zip",
            download_directory = "downloaded_tools/slicetrackgeni",
            host_type = "sharepoint_onedrive",
            zipped_exe_name = "main/main.exe"
            )
        self.tabs.addTab(self.tab6,"SliceTrackGeni")

        self.tabs.setCurrentIndex(0)   
