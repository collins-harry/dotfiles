
        excel_sheets = {
            "name": self.final_file,
            "sheets": [
                {
                    "worksheet_title": "ALL",
                    "heading note": "Contact Harry Collins,  if you have any questions",
                    "headings": all_headings,
                    "values": values,
                    # "tab_color": "red",
                },
                {
                    "worksheet_title": "",
                    "heading note": "Contact Harry Collins,if you have any questions",
                    "headings": ,
                    "values": ,
                    "right_borders": ["A","D","H","K","N"],
                    "tab_color": "red",
                    "final_row_color": "light_green"
                },
                ]
            }

class Excel():
    """V5 from edc2kill"""
    def __init__(self):
        pass

    def print_to_excel(self, tables):
        self.output_path = tables["name"]
        print(self.output_path)
        """ Version 3 """
        print("*Printing to Excel*")
        try:
            self.output_path = self._delete_old_output_file()
        except Exception as e:
            trigger_exception( f"EXCEPTION: Could not remove old file ({self.output_path}) as it is open in another application (probably Excel).\n\nTry closing the file and running again", e=e)
        with xlsxwriter.Workbook(self.output_path) as workbook:
            formats = self._add_styles_to_workbook(workbook)
            for table in tables["sheets"]:
                worksheet = workbook.add_worksheet(table["worksheet_title"])
                if heading_note := table.get("heading note"):
                    worksheet.write(0, 0, heading_note)
                    startrow = 1
                else:
                    startrow = 0
                right_border_indices = self._convert_letters_to_indices(right_borders) if (right_borders := table.get("right_borders")) else []
                if tab_color := table.get("tab_color"):
                    worksheet.set_tab_color(tab_color)
                for column, heading in enumerate(table["headings"]):
                    worksheet.write(startrow, column, heading, formats[f"light_blue{'_right_border' if column in right_border_indices else ''}"])
                for row_index, row_values in enumerate(table["values"]):
                    for column_index, value in enumerate(row_values):
                        if (color := table.get("final_row_color")) and (row_index == len(table["values"])-1):
                            worksheet.write(startrow + 1 + row_index, column_index, value, formats[f"{color}{'_right_border' if column_index in right_border_indices else ''}"])
                        else:
                            worksheet.write(startrow + 1 + row_index, column_index, value, formats[f"none{'_right_border' if column_index in right_border_indices else ''}"])
                self._set_column_width(worksheet, table["headings"], table["values"])

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

    def _add_styles_to_workbook(self, workbook):
        style_lookup = {
            "dark_blue": {"bg_color": "#b4c6e7"},
            "light_blue": {"bg_color": "#d9e1f2"},
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
        }
        return {name: workbook.add_format(style) for name, style in style_lookup.items()}

    def open_excel(self):
        file_path = self.output_path
        subprocess.Popen(str(file_path), shell=True)
