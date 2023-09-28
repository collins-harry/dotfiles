import sys
import os
from pathlib import Path
from PyQt5 import QtWidgets, uic
import logging
import xlsxwriter
try:
    from foldercopier import Foldercopier
    from lib.resource_path import resource_path
except:
    from .foldercopier import Foldercopier
    from .lib.resource_path import resource_path

try: 
    logger 
except: 
    logger = logging.getLogger(__name__)


app_layout = resource_path(r"lib\layout_foldercopier.ui")
Ui_MainWindow, QtBaseClass = uic.loadUiType(app_layout)
class FoldercopierLauncher(QtWidgets.QMainWindow, Ui_MainWindow):

    def __init__(self):
        super().__init__()
        Ui_MainWindow.__init__(self)
        self.setupUi(self)
        # App options
        self._folder_to_copy_path = None
        self._destination_path = None
        self._options = {
                "ignore_dotfiles": False, 
                "mirror": False,
                "verbose": False,
                }
        self._hvqkconfigs_output_dir = None
        self._mtpl_output_dir = None
        self._class_voltage_lmax = {}
        self._output_path = None
        # GUI elements
        self._tppath_text_prompt = self.textEditCopyPath.copy()
        self.buttonBrowseForFolderToCopy.clicked.connect(self._run_copy_folder_browser)
        self.buttonBrowseForPasteDirectory.clicked.connect(self._run_destination_folder_browser)
        self.buttonRunScript.clicked.connect(self.run_script)
        self.dotfilesCheckBox.stateChanged.connect(self._toggle_options)
        self.mirrorCheckBox.stateChanged.connect(self._toggle_options)
        self.verboseCheckBox.stateChanged.connect(self._toggle_options)

    def run_script(self):
        try:
            foldercopier = Foldercopier()
            if self._folder_to_copy_path:
                foldercopier.set_folder_to_copy_path(self._folder_to_copy_path)
            else:
                self.trigger_exception("Script won't work, you need to select a test program folder to copy, contact Harry Collins for help")
                return
            if self._destination_path:
                foldercopier.set_destination_folder_path(self._destination_path)
            else:
                self.trigger_exception("Script won't work, you need to select a destination folder, contact Harry Collins for help")
                return
            foldercopier.copy_folder(ignore_dotfiles=self._options["ignore_dotfiles"], mirror=self._options["mirror"], verbose=self._options["verbose"])
        except Exception as e:
            logger.exception(e)
            self.trigger_exception("EXCEPTION occured when running foldercopier, ping Harry Collins for help")
    
    def _toggle_options(self):
        if self.verboseCheckBox.isChecked():
            print("User checked \"Verbose\"")
            self._options["verbose"] = True
        else:
            print("User unchecked \"Verbose\"")
            self._options["verbose"] = False

        if self.mirrorCheckBox.isChecked():
            print("User checked \"Mirror\"")
            self._options["mirror"] = True
        else:
            print("User unchecked \"Mirror\"")
            self._options["mirror"] = False

        if self.dotfilesCheckBox.isChecked():
            print("User checked \"Ignore dotdirectories\"")
            self._options["ignore_dotfiles"] = True
        else:
            print("User unchecked \"Ignore dotfiles\"")
            self._options["ignore_dotfiles"] = False

    def _run_copy_folder_browser(self):
        # self._tp_folder_path = QtWidgets.QFileDialog.getOpenFileName()
        if self._folder_to_copy_path:
            path = QtWidgets.QFileDialog.getExistingDirectory(
                    self, caption="Select Folder To Copy", directory=os.path.split(self._folder_to_copy_path)[0]
                    )
        else:
            path = QtWidgets.QFileDialog.getExistingDirectory()
        if path:
            self._folder_to_copy_path = path
            print(f"Selected folder to copy: {self._folder_to_copy_path}")
            self.textEditCopyPath.clear()
            self.textEditCopyPath.insertHtml(self._folder_to_copy_path)

    def _run_destination_folder_browser(self):
        # self._tp_folder_path = QtWidgets.QFileDialog.getOpenFileName()
        if self._destination_path:
            path = QtWidgets.QFileDialog.getExistingDirectory(
                    self, caption="Select Destination Folder", directory=os.path.split(self._destination_path)[0]
                    )
        else:
            path = QtWidgets.QFileDialog.getExistingDirectory()
        if path:
            self._destination_path = path
            print(f"Selected destination directory: {self._destination_path}")
            self.textEditDestinationPath.clear()
            self.textEditDestinationPath.insertHtml(self._destination_path)

    def trigger_exception(self, message):
        print(message)
        QtWidgets.QMessageBox.about(self, "Exception", message)

if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    ex = FoldercopierLauncher()
    ex.show()
    sys.exit(app.exec_())
