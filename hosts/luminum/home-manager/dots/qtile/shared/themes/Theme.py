from dataclasses import dataclass
from libqtile.log_utils import logger
from os.path import join, exists, expanduser, dirname, basename, splitext, isfile
from typing import List


def construct_path(path: str, default_dir: str, file_extension="") -> str:
    """
    Returns default_dir/path if path does not exist, adds file_extension if one is not found,
    expands home dir if not found.
    """

    path = expanduser(path)

    if file_extension and len(path.split(".")) == 1:
        path += file_extension

    if exists(path):
        return path

    full_path: str = join(default_dir, path)
    if exists(full_path):
        return full_path

    logger.warning(f"Can't find {path} or {full_path}")
    return path


def deconstruct_path(path: str) -> str:
    """
    Reverses construct_path, returning an extensionless filename.
    """

    if isfile(path):
        return splitext(basename(path))[0]

    home_dir: str = expanduser("~")
    if path.startswith(home_dir):
        path = f"expanduser('~{path[len(home_dir):]}')"

    return path


@dataclass
class ThemeIcons:
    """
    Stores and standerdizes used theme icons.
    """

    memory_usage: str
    vpn_active: str
    vpn_inactive: str
    groups_logo: str

    icon_path: str = join(dirname(__file__), "icons")

    def __post_init__(self):
        """
        Formatting icon paths.
        """

        for name, value in self.__dict__.items():
            proper_path = construct_path(value, self.icon_path, ".png")
            object.__setattr__(self, name, proper_path)


@dataclass
class ThemeColors:
    """
    Stores and standerdizes used theme colors.
    """

    top_gradient: str
    bottom_gradient: str
    text_highlight: str
    active_highlight: str
    group_background: str
    textbox_background: str
    vpn_background: str
    volume_background: str
    network_background: str
    memory_background: str
    cpu_background: str
    clock_background: str
    bar_background: str
    border_active: str
    border_inactive: str


@dataclass
class Theme:
    """
    Full Qtile theme.
    """

    colors: ThemeColors
    icons: ThemeIcons
    wallpaper: str

    wallpaper_dir: str = expanduser("~/.config/wallpapers")

    def __post_init__(self):
        object.__setattr__(
            self,
            "wallpaper",
            construct_path(self.wallpaper, self.wallpaper_dir, ".png"),
        )
