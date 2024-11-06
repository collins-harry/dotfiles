from pathlib import Path
import glob
import os
import re
import copy
import subprocess
import string
import xlsxwriter
import ctypes

def main():
    stats = [
        ["Percentage of programs that match", f"{output['engines_match'].sum() / len(output) * 100}%"],
    ]

    output = output.replace({True: 'TRUE', False: 'FALSE'})
    # output = output.replace([np.nan], [None])
        
    excel_sheets = {
        "name": "output/compare.xlsx",
        "sheets": [
            {
                "worksheet_title": "Statistics",
                "headings": ["Statistic", "Value"],
                "values": stats,
                "tab_color": "pastel_green",
            },
            {
                "worksheet_title": "ALL",
                "heading note": "Contact Harry Collins,  if you have any questions",
                "headings": output.columns.tolist(),
                "values": output.values.tolist(),
                # "values": df[[
                #     "",
                #     ]].values.tolist(),
                "merge_headers": [
                    {"level":1, "cell_range":["F","G"], "text":"EventSetDetails", "format":"dark_blue_center"},
                    {"level":1, "cell_range":["H","I"], "text":"EventSetTypeDetails", "format":"dark_blue_center"},
                    {"level":1, "cell_range":["J","M"], "text":"LayerDetails", "format":"dark_blue_center"},
                    {"level":1, "cell_range":["N","S"], "text":"LayerPerfCosts", "format":"dark_blue_center"},
                ],
                "conditional_formatting": [ 
                    {"range": "A1:X9999", "type": "cell", "criteria": "==", "value": '"FALSE"', "format": "conditional_red"},
                    {"range": "A1:X9999", "type": "cell", "criteria": "==", "value": '"TRUE"',  "format": "conditional_green"},
                    {"range": "A1:X9999", "type": "cell", "criteria": "==", "value": '"WARNING"',  "format": "conditional_yellow"},
                ],
                "right_borders": ["A", "E", "G", "I", "M", "S"],
                # "final_row_color": "light_green",
                "set_column_width": True,
                "tab_color": "pastel_purple",
                "freeze_headers": True,
                "freeze_first_column": True,
            },
            ]
        }

    excel = Excel()
    excel.print_to_excel(excel_sheets)
    excel.open_excel()

class Excel():

    def __init__(self):
        pass

    def print_to_excel(self, tables):
        self.output_path = tables["name"]
        print(self.output_path)
        """ Version 4 """
        print("*Printing to Excel*")
        try:
            self.output_path = self._delete_old_output_file()
        except Exception as e:
            self._trigger_exception( f"EXCEPTION: Could not remove old file ({self.output_path}) as it is open in another application (probably Excel).\n\nTry closing the file and running again", e=e)
        with xlsxwriter.Workbook(self.output_path, {'nan_inf_to_errors': True}) as workbook:
            formats = self._add_styles_to_workbook(workbook)
            for table in tables["sheets"]:
                worksheet = workbook.add_worksheet(table["worksheet_title"])
                if heading_note := table.get("heading_note"):
                    worksheet.write(0, 0, heading_note)
                    startrow = 1
                else:
                    startrow = 0
                if merge_headers := table.get("merge_headers"):
                    max_level = 0
                    for merge in merge_headers:
                        row = startrow + merge["level"]
                        if merge["level"] > max_level:
                            max_level = merge["level"]
                        if merge['cell_range'][0] == merge['cell_range'][1]:
                            worksheet.write(f"{merge['cell_range'][0]}{row}", merge["text"], formats[merge["format"]])
                        else:
                            cell_range = f"{merge['cell_range'][0]}{row}:{merge['cell_range'][1]}{row}"
                            worksheet.merge_range(cell_range, merge["text"], formats[merge["format"]])
                    startrow = startrow + max_level
                right_border_indices = self._convert_letters_to_indices(right_borders) if (right_borders := table.get("right_borders")) else []
                for column, heading in enumerate(table["headings"]):
                    worksheet.write(startrow, column, heading, formats[f"light_blue{'_right_border' if column in right_border_indices else ''}"])
                startrow += 1
                for row_index, row_values in enumerate(table["values"]):
                    for column_index, value in enumerate(row_values):
                        if (color := table.get("final_row_color")) and (row_index == len(table["values"])-1):
                            worksheet.write(startrow + row_index, column_index, value, formats[f"{color}{'_right_border' if column_index in right_border_indices else ''}"])
                        else:
                            worksheet.write(startrow + row_index, column_index, value, formats[f"none{'_right_border' if column_index in right_border_indices else ''}"])
                if tab_color := table.get("tab_color"):
                    worksheet.set_tab_color(self.style_lookup[tab_color]["bg_color"])
                if table.get("set_column_width", True):
                    self._set_column_width(worksheet, table["headings"], table["values"])
                if table.get("freeze_headers", False) or table.get("freeze_first_column", False):
                    freeze_row = startrow if table.get("freeze_headers", False) else 0
                    freeze_column = 1 if table.get("freeze_first_column", False) else 0
                    worksheet.freeze_panes(freeze_row, freeze_column)
                if table.get("conditional_formatting"):
                    self._set_conditional_formatting(worksheet, table["conditional_formatting"], formats)

    def _convert_letters_to_indices(self, columns):
        return [string.ascii_uppercase.index(column_letter) for column_letter in columns]

    def _delete_old_output_file(self):
        """Delete old output file, If unable to be deleted than append a ([0-9]) to the output_name
        self._download_dir_path"""
        # print("Deleting old download directories...")
        output_file_path = Path(self.output_path)
        output_regex = str(output_file_path.parent / (output_file_path.stem + "*"))
        matching_output_file_paths = glob.glob(output_regex)
        for matching_output_file in matching_output_file_paths:
            try:
                os.remove(matching_output_file)
            except PermissionError as e:
                pass
        if not os.path.exists(output_file_path):
            return output_file_path
        remaining_matching_output_file_paths = glob.glob(output_regex)
        versions = []
        for remaining_output_file in remaining_matching_output_file_paths:
            if i := re.findall(f"{output_file_path.stem} \(([0-9]+)\)", remaining_output_file):
                print("remaining_output_file: ", i)
                for version in i:
                    versions.append(int(version))
        print("versions: ", versions)
        if versions:
            versions.sort()
            new_version = int(versions[-1]) + 1
        else:
            new_version = 1
        print(f"Unable to delete old output_file, so appended ({new_version}) to new output name")
        new_output_path = output_file_path.with_name(f"{output_file_path.stem} ({new_version}){output_file_path.suffix}")
        print("new_output_name", new_output_path.name)
        self.output_path = new_output_path
        return self.output_path

    def _set_column_width(self, worksheet, headings, values):
        """great"""
        columns = []
        headandcolumn = copy.deepcopy(values)
        headandcolumn.insert(0, headings)
        max_lengths = [0 for i in range(len(headandcolumn[0]))]
        for row in headandcolumn:
            for col_id, cell_value in enumerate(row):
                if type(cell_value) == str and max_lengths[col_id] < len(cell_value):
                    max_lengths[col_id] = len(cell_value)
        for column_index, column_width in enumerate(max_lengths):
            worksheet.set_column(column_index, column_index, column_width + 1)

    def _set_conditional_formatting(self, worksheet, conditional_formats, formats):
        for conditional_format in conditional_formats:
            if conditional_format["type"] == "formula":
                worksheet.conditional_format(conditional_format["range"], {"type": conditional_format["type"], 
                                                                           "criteria": conditional_format["criteria"], 
                                                                           "format": formats[conditional_format["format"]]})
            else:
                worksheet.conditional_format(conditional_format["range"], {"type": conditional_format["type"], 
                                                                           "criteria": conditional_format["criteria"], 
                                                                           "value": conditional_format["value"],
                                                                           "format": formats[conditional_format["format"]]})

    def _add_styles_to_workbook(self, workbook):
        self.style_lookup = {
            "dark_blue": {"bg_color": "#b4c6e7"},
            "dark_blue_center": {"bg_color": "#b4c6e7", "align":"center", "right":True, "left":True},
            "light_blue": {"bg_color": "#d9e1f2"},
            "light_blue_center": {"bg_color": "#d9e1f2", "align":"center", "right":True, "left":True},
            "dark_blue_right_border": {"bg_color": "#b4c6e7", "right": True},
            "light_blue_right_border": {"bg_color": "#d9e1f2", "right": True},
            "light_grey_all_border": {"bg_color": "#e7e6e6", "border": True},
            "darker_blue_all_border": {"bg_color": "#8DB4E2", "border": True},
            "none": {},
            "none_right_border": {"right": True},
            "none_bottom_border": {"bottom": True},
            "none_bottom_border_right_border": {"bottom": True, "right": True},
            "yellow_bottom_border": {"bg_color": "#FFFF00", "bottom": True},
            "yellow_bottom_border_right_border": {"bg_color": "#FFFF00", "bottom": True, "right": True},
            "green": {"bg_color": "#c6efce"},
            "green_right_border": {"bg_color": "#c6efce", "border":True},
            "light_green": {"bg_color": "#92D050"},
            "light_green_right_border": {"bg_color": "#92D050", "border":True},
            "dark_yellow": {"bg_color": "#ffeb9c"},
            "red": {"bg_color": "#ffc7ce"},
            "red_right_border": {"bg_color": "#ffc7ce", "border":True},
            "conditional_red": {'bg_color': '#FFC7CE', 'font_color': '#9C0006'},
            "conditional_yellow": {'bg_color': '#FFEB9C', 'font_color': '#9C6500'},
            "conditional_green": {'bg_color': '#C6EFCE', 'font_color': '#006100'},
            "pastel_green": {"bg_color": "#D8E4BC"},
            "pastel_purple": {"bg_color": "#CCC0DA"},
            "pastel_blue": {"bg_color": "#B8CCE4"},
            "pastel_red": {"bg_color": "#E6B8B7"},
            "percentage": {'num_format': '0.00%'},
        }
        return {name: workbook.add_format(style) for name, style in self.style_lookup.items()}

    def _trigger_exception(self, message, title="EXCEPTION", uType=0):
        print(message)
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


    def open_excel(self):
        file_path = self.output_path
        subprocess.Popen(str(file_path), shell=True)

