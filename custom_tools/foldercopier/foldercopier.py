try:
    from .lib import walk_scandir
    from .lib import on_rm_error
except:
    from lib.fastio_improved import walk_scandir
    from lib.on_rm_error import on_rm_error
from time import perf_counter as timer
import ctypes  # An included library with Python install.   
import logging
import os
import subprocess

try:
    logger
except:
    logger = logging.getLogger(__name__)


def main():
    # tp_folder_path = r"C:\Users\Hcollins\OneDrive - Intel Corporation\projects\26p6_12N_881_FULLTP_0" #881 12N
    # tp_folder_path = r"C:/Users/Hcollins/OneDrive - Intel Corporation/projects/29_881_12P_FULLTP_0" # 881 12P
    # tp_folder_path = r"C:\Users\Hcollins\OneDrive - Intel Corporation\projects\28p3_31H00_682_FULLTP_0" # 682 31H
    # tp_folder_path = r"C:\Users\Hcollins\OneDrive - Intel Corporation\projects\30p2_881_12R00_FULLTP_1" # 881 12R
    # tp_folder_path = r"C:\Users\Hcollins\OneDrive - Intel Corporation\projects\30p2_682_32B_FULLTP_0" # 682 32B
    # tp_folder_path = r"C:\Users\Hcollins\OneDrive - Intel Corporation\projects\34p3_682_32D_FULLTP_0" # 682 32D
    # tp_folder_path = r"C:\Users\hcollins\OneDrive - Intel Corporation\projects\36p3_601_51K_FULLTP_0" # 601 51K
    # tp_folder_path = r"C:\Users\Hcollins\OneDrive - Intel Corporation\projects\36p3_282_41C01_FULLTP_0" # 282 41C01
    # tp_folder_path = r"\\s46file1.cd.intel.com\sdx\program\1274\eng\hdmtprogs\adl_sds\hcollins\37p5_282_R1_41E_FULLTP_0" # 282 41C01
    # folder_to_copy = r"\\s46file1.cd.intel.com\sdx\program\1274\prod\hdmtprogs\rpl_sds\RPLSDJXA1H70E002143"
    # tp_folder_path = r"\\s46file1.cd.intel.com\sdx\program\1274\prod\hdmtprogs\rpl_sds\RPLSDJXA9H70F002143" # RPL 70F 44p1
    # tp_folder_path = r"\\s46file1.cd.intel.com\sdx\program\1274\eng\hdmtprogs\adl_sds\TestProgram\ADLEBJX32J1453T32J" # ADL682 32J mid_integ
    # tp_folder_path = r"I:\program\1274\prod\hdmtprogs\adl_sds\ADLSDJXR1H41J112147"
    # tp_folder_path = r"I:/program/1274/prod/hdmtprogs/icd_sds/ICDSDJXU1H31G002150"
    # folder_to_copy = r"I:\program\1274\prod\hdmtprogs\adl_sds\ADLSDJXL1H32N012204"
    folder_to_copy = r"..\temp23"
    folder_to_paste_folder = r"C:\Users\Hcollins\OneDrive - Intel Corporation\projects"
    foldercopier = Foldercopier()
    foldercopier.set_folder_to_copy_path(folder_to_copy)
    foldercopier.set_destination_folder_path(folder_to_paste_folder)
    foldercopier.copy_folder(ignore_dotfiles=True, mirror=True, verbose=True)
    # waterfallpuller = Waterfallpuller()
    # waterfallpuller.set_test_program_directory(tp_folder_path)
    # waterfallpuller.set_options(options)
    # waterfallpuller.delete_old_download_directories()
    # waterfallpuller.populate_indicator_voltages()
    # waterfallpuller.find_hvqk_configs()
    # waterfallpuller.download_hvqk_configs()
    # waterfallpuller.find_mtpls()
    # waterfallpuller.download_mtpls()
    # waterfallpuller.parse_mtpls()
    # waterfallpuller.parse_all_hvqk_configs(class_voltage_lmax)
    # waterfallpuller.print_to_excel(output_path)
    # waterfallpuller.open_excel(output_path)


class Foldercopier():

    def __init__(self):
        self._path_folder_to_copy = None
        self._name_folder_to_copy = None
        self._path_destination_folder = None
        self._options = None

    def set_folder_to_copy_path(self, directory):
        """"""
        try:
            os.scandir(directory)
        except OSError as e:
            if e.winerror == 3:
                self._trigger_exception(f"EXCEPTION: Test Program Directory not found.\n\nAre you on the VPN? \nIs your I-drive mapped correctly?\n\nContact Harry Collins for help.\n\n{e}", uType="MB_ICONEXCLAMATION", e=e)
                raise
            else:
                self._trigger_exception(f"EXCEPTION: Unknown OSError exception, please ping Harry Collins.\n\n{e}", uType="MB_ICONEXCLAMATION", e=e)
                raise
        except Exception as e:
            self._trigger_exception(f"EXCEPTION: Unknown OSError exception, please ping Harry Collins.\n\n{e}", uType="MB_ICONEXCLAMATION", e=e)
            raise
        self._path_folder_to_copy = directory
        self._name_folder_to_copy = os.path.split(directory)[1]

    def set_destination_folder_path(self, directory):
        """"""
        try:
            os.scandir(directory)
        except OSError as e:
            if e.winerror == 3:
                self._trigger_exception(f"EXCEPTION: Test Program Directory not found.\n\nAre you on the VPN? \nIs your I-drive mapped correctly?\n\nContact Harry Collins for help.\n\n{e}", uType="MB_ICONEXCLAMATION", e=e)
                raise
            else:
                self._trigger_exception(f"EXCEPTION: Unknown OSError exception, please ping Harry Collins.\n\n{e}", uType="MB_ICONEXCLAMATION", e=e)
                raise
        except Exception as e:
            self._trigger_exception(f"EXCEPTION: Unknown OSError exception, please ping Harry Collins.\n\n{e}", uType="MB_ICONEXCLAMATION", e=e)
            raise
        self._path_destination_folder = directory

    def set_options(self, options):
        """"""
        self._options = options

    def copy_folder(self, ignore_dotfiles=False, mirror=False, verbose=False):
        if self._path_destination_folder and self._path_folder_to_copy:
            fromdir = self._path_folder_to_copy
            # print(f"full_destination_path: {os.path.join(self._path_destination_folder, self._name_folder_to_copy)}")
            todir = os.path.join(self._path_destination_folder, self._name_folder_to_copy)
            # print(["robocopy", fromdir, todir, "/E", "/NFL", "/NDL", "/MT:32"])
            copy_command = ["robocopy", fromdir, todir, "/E", "/ns", "/MT:64", "/w:3"]
            if ignore_dotfiles: copy_command += ["/XD", r".*"]
            if mirror: copy_command += ["/MIR"]
            if verbose: 
                copy_command += ["/v"]
            else:
                copy_command += ["/NFL", "/NDL" ]

            subprocess.call(copy_command)
            print("TP successfully copied!")
        else:
            if not self._path_folder_to_copy:
                self._trigger_exception(f"You need to browse for a TP to copy!!", uType="MB_ICONEXCLAMATION")
            else:
                self._trigger_exception(f"You need to browse for a directory to copy your TP to!!", uType="MB_ICONEXCLAMATION")

    def _trigger_exception(self, message, title="EXCEPTION", uType="MB_ICONERROR", e=None):
        if e:
            try:
                logger
            except:
                logger = logging.getLogger(__name__)
            logger.exception(e)
        uTypes = {
                0: 0,
                "MB_ICONEXCLAMATION": 0x30,
                "MB_ICONWARNING": 0x30,
                "MB_ICONINFORMATION": 0x40,
                "MB_ICONASTERISK": 0x40,
                "MB_ICONQUESTION": 0x20,
                "MB_ICONSTOP": 0x10,
                "MB_ICONERROR": 0x10,
                "MB_ICONHAND": 0x10,
                }
        ctypes.windll.user32.MessageBoxW(0, message, title, uTypes[uType])

if __name__=="__main__":
    # import cProfile
    # cProfile.run('main()')   
    main()


