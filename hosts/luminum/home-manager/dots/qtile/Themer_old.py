"""
This is a GUI QTile theme creation tool made largely by ChatGPT. PYQT6 must be installed to use.
"""

from shared.utils.format import get_theme, format_theme_file
from os.path import basename
from subprocess import Popen
from dataclasses import asdict
from PyQt6.QtWidgets import (
    QApplication,
    QWidget,
    QVBoxLayout,
    QLabel,
    QPushButton,
    QColorDialog,
    QFormLayout,
    QLineEdit,
    QHBoxLayout,
    QFileDialog,
)
from PyQt6.QtGui import QColor
from shared.themes import Theme


class Themer(QWidget):
    def __init__(self, reload_on_save=True):
        super().__init__()

        self.RELOAD_ON_SAVE: bool = reload_on_save

        self.setWindowTitle("Themer Color Picker")

        # Prepare dictionaries to store selected colors and icons
        self.selected_colors = {
            field: "#FFFFFF" for field in Theme.ThemeColors.__annotations__
        }
        self.selected_icons = {field: "" for field in Theme.ThemeIcons.__annotations__}
        self.wallpaper_path = ""
        self.theme_path = ""  # Path for saving/loading themes

        # Main layout
        layout = QVBoxLayout()

        # Form layout for color fields
        self.form_layout = QFormLayout()
        self.color_labels = {}

        for field in Theme.ThemeColors.__annotations__:
            self.create_color_picker_row(field)

        layout.addLayout(self.form_layout)

        # Form layout for icons
        self.icon_layout = QFormLayout()
        self.icon_fields = {}

        for field in Theme.ThemeIcons.__annotations__:
            self.create_icon_picker_row(field)

        layout.addLayout(self.icon_layout)

        # Wallpaper path field
        self.wallpaper_label = QLabel("Wallpaper Path:")
        self.wallpaper_input = QLineEdit()
        self.wallpaper_input.setReadOnly(False)
        self.wallpaper_button = QPushButton("Select Wallpaper")
        self.wallpaper_button.clicked.connect(self.select_wallpaper)

        wallpaper_hbox = QHBoxLayout()
        wallpaper_hbox.addWidget(self.wallpaper_input)
        wallpaper_hbox.addWidget(self.wallpaper_button)

        layout.addWidget(self.wallpaper_label)
        layout.addLayout(wallpaper_hbox)

        # Theme path field
        self.theme_path_label = QLabel("Theme Path:")
        self.theme_path_input = QLineEdit()
        self.theme_path_input.setReadOnly(False)
        self.theme_path_button = QPushButton("Select Theme Path")
        self.theme_path_button.clicked.connect(self.select_theme_path)

        theme_path_hbox = QHBoxLayout()
        theme_path_hbox.addWidget(self.theme_path_input)
        theme_path_hbox.addWidget(self.theme_path_button)

        layout.addWidget(self.theme_path_label)
        layout.addLayout(theme_path_hbox)

        # Save and Load buttons
        button_hbox = QHBoxLayout()
        save_button = QPushButton("Save Theme")
        save_button.clicked.connect(self.save_theme)
        load_button = QPushButton("Load Theme")
        load_button.clicked.connect(self.load_theme_from_file)

        button_hbox.addWidget(save_button)
        button_hbox.addWidget(load_button)

        layout.addLayout(button_hbox)

        self.setLayout(layout)

    def create_color_picker_row(self, field_name):
        """Creates a row in the form layout for each theme color."""
        color_display = QLineEdit(self.selected_colors[field_name])
        color_display.setReadOnly(False)
        color_display.setStyleSheet(
            f"background-color: {self.selected_colors[field_name]};"
        )

        # Connect the returnPressed signal to handle_return_pressed
        color_display.returnPressed.connect(self.handle_return_pressed)

        label = QLabel(f"{field_name.replace('_', ' ').title()}:")

        self.color_labels[field_name] = color_display

        button = QPushButton("Pick Color")
        button.setFixedWidth(100)  # Set a fixed width for the buttons
        button.clicked.connect(lambda _, field=field_name: self.pick_color(field))

        hbox = QHBoxLayout()
        hbox.addWidget(color_display)
        hbox.addWidget(button)

        self.form_layout.addRow(label, hbox)

    def handle_return_pressed(self):
        """Update the GUI when Enter is pressed after editing a field."""
        self.update_gui_from_theme(get_theme(basename(self.theme_path)))
        pass

    def pick_color(self, field_name):
        """Open the color dialog to pick a color."""
        current_color = self.selected_colors.get(
            field_name, "#FFFFFF"
        )  # Default to white if not set
        color = QColorDialog.getColor(QColor(current_color))

        if color.isValid():
            # Store the selected color in the dictionary
            self.selected_colors[field_name] = color.name()
            self.color_labels[field_name].setText(color.name())
            self.color_labels[field_name].setStyleSheet(
                f"background-color: {color.name()};"
            )

    def create_icon_picker_row(self, field_name):
        """Creates a row in the form layout for each theme icon."""
        label = QLabel(f"{field_name.replace('_', ' ').title()}:")
        icon_display = QLineEdit(self.selected_icons[field_name])
        icon_display.setReadOnly(False)
        icon_display.setStyleSheet("background-color: #E0E0E0;")

        self.icon_fields[field_name] = icon_display

        button = QPushButton("Select Icon")
        button.setFixedWidth(100)  # Set a fixed width for the buttons
        button.clicked.connect(lambda _, field=field_name: self.select_icon(field))

        hbox = QHBoxLayout()
        hbox.addWidget(icon_display)
        hbox.addWidget(button)

        self.icon_layout.addRow(label, hbox)

    def select_icon(self, field_name):
        """Open the file dialog to select an icon."""
        file_path, _ = QFileDialog.getOpenFileName(self, "Select Icon File")

        if file_path:
            # Store the selected icon path in the dictionary
            self.selected_icons[field_name] = file_path
            self.icon_fields[field_name].setText(file_path)

    def select_wallpaper(self):
        """Open the file dialog to select a wallpaper."""
        file_path, _ = QFileDialog.getOpenFileName(self, "Select Wallpaper File")

        if file_path:
            self.wallpaper_path = file_path
            self.wallpaper_input.setText(file_path)

    def select_theme_path(self):
        """Open the file dialog to select a path for saving the theme."""
        file_path, _ = QFileDialog.getSaveFileName(
            self, "Save Theme File", "", "Python files (*.py)"
        )

        if file_path:
            self.theme_path = file_path
            self.theme_path_input.setText(file_path)

    def reload_qtile_config(self):
        Popen("qtile cmd-obj -o cmd -f restart", shell=True)

    def save_theme(self):
        """Create and save a Theme instance to the specified file path."""
        if not self.theme_path:
            print("No theme path selected.")
            return

        theme_colors = Theme.ThemeColors(**self.selected_colors)
        theme_icons = Theme.ThemeIcons(**self.selected_icons)
        theme = Theme.Theme(
            colors=theme_colors, icons=theme_icons, wallpaper=self.wallpaper_path
        )

        with open(self.theme_path, "w") as file:
            file.write(format_theme_file(theme))

        print(f"Theme saved to {self.theme_path}")
        if self.RELOAD_ON_SAVE:
            self.reload_qtile_config()

    def load_theme_from_file(self):
        """Load a theme from a Python file and update the GUI."""
        file_path, _ = QFileDialog.getOpenFileName(
            self, "Open Theme File", "", "Python files (*.py)"
        )

        print(f"Loading theme: {file_path}")

        if file_path:
            theme = get_theme(basename(file_path))
            print(format_theme_file(theme))

            self.theme_path = file_path
            self.theme_path_input.setText(file_path)
            self.update_gui_from_theme(theme)

    def update_gui_from_theme(self, theme):
        """Update the GUI with the loaded theme data."""
        self.selected_colors = asdict(theme.colors)
        self.selected_icons = asdict(theme.icons)
        self.wallpaper_path = theme.wallpaper

        for field, color in self.selected_colors.items():
            self.color_labels[field].setText(color)
            self.color_labels[field].setStyleSheet(f"background-color: {color};")

        for field, icon in self.selected_icons.items():
            self.icon_fields[field].setText(icon)

        self.wallpaper_input.setText(self.wallpaper_path)

    def closeEvent(self, event):
        """Handle the close event properly."""
        print("Application closed.")
        event.accept()


def start():
    app = QApplication([])
    window = Themer()
    window.show()
    app.exec()


if __name__ == "__main__":
    start()
    # get_theme("zelda.py")