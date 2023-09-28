import sys
import os
import re
from main_inputs.appupdator import AppUpdator
from pathlib import Path
from PyQt5 import QtWidgets, uic, QtCore
from PyQt5.QtGui import QIcon
from PyQt5.QtCore import pyqtSlot
from main_inputs.ThermalTools import ThermalTools
from main_inputs.HWAuditingTools import HWAuditingTools
from main_inputs.KappaPilotTools import KappaPilotTools
from main_inputs.TPModificationTools import TPModificationTools
from main_inputs.DataAnalysisTools import DataAnalysisTools
from main_inputs.TPAuditTools import TPAuditTools
from main_inputs.MiscellaneousTools import MiscellaneousTools

def resource_path(relative_path):
    """ Get absolute path to resource, works for dev and for PyInstaller """
    path = Path(__file__).parent / relative_path
    return str(path)

app_layout = resource_path(r"main_inputs\layouts\layout_main.ui")
Ui_MainWindow, QtBaseClass = uic.loadUiType(app_layout)
class Toolshed(QtWidgets.QMainWindow, Ui_MainWindow):

    def __init__(self):
        super().__init__()
        self.setWindowIcon(QIcon('PCSpuller/pcspuller_code/icons/pcspuller.ico'))
        Ui_MainWindow.__init__(self)
        # set the title
        self.setupUi(self)
        self.tab1 = ThermalTools()
        self.tab2 = HWAuditingTools()
        self.tab3 = KappaPilotTools()
        self.tab4 = TPModificationTools()
        self.tab5 = DataAnalysisTools()
        self.tab6 = TPAuditTools()
        self.tab7 = MiscellaneousTools()
        self.tabs.addTab(self.tab1,"Thermal")
        self.tabs.addTab(self.tab2,"HWAuditing")
        self.tabs.addTab(self.tab3,"KappaPilot")
        self.tabs.addTab(self.tab4,"TP/Config Editing")
        self.tabs.addTab(self.tab5,"DataAnalysis")
        self.tabs.addTab(self.tab6,"TPAudits")
        self.tabs.addTab(self.tab7,"Miscellaneous")
        # self.tabs.currentChanged.connect(self.slotCurrentChanged)
        self.tabs.setCurrentIndex(0)   
        self.show()

    def slotCurrentChanged(self, i):
        """Lazy-loads the tab's page if shown for the first time."""
        self.tabs.widget(i).widget()

if __name__ == '__main__':
    print("* Welcome to Toolshed *")
    if re.search("python.exe", sys.executable):
        print("** Raw python version detected **")
        os.chdir(os.path.dirname(os.path.abspath(__file__)))
    else:
        print("** EXE version detected **")
        os.chdir(os.path.dirname(os.path.abspath(sys.executable)))
    print("** Checking for updates to Toolshed.exe launcher **")
    toolshed_launcher = AppUpdator(
            "Toolshed", 
            "Documents/special/Toolshed.exe",
            "Toolshed.exe",
            download_directory = "..",
            host = "sharepoint_onedrive",
            )
    success = toolshed_launcher.update_app()
    if success == False: sys.exit(1)
    if os.path.exists(r"..\PCSpuller.exe"):
        print("** PCSpuller.exe launcher exists ** ")
        print("*** Checking for updates to PCSpuller.exe launcher ***")
        pcspuller_launcher_updator = AppUpdator(
                "Toolshed",
                "https://gitlab.devtools.intel.com/hcollins/Toolshed/-/raw/releases/PCSpuller.exe",
                "PCSpuller.exe",
                download_directory = "..",
                )
        success = pcspuller_launcher_updator.update_app()
        if success == False: sys.exit(1)
    print("** Starting Toolshed **")
    # os.environ["QT_AUTO_SCREEN_SCALE_FACTOR"] = "1"
    app = QtWidgets.QApplication(sys.argv)
    # app.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling)
    ex = Toolshed()
    print("** Toolshed Started **")
    sys.exit(app.exec_())
