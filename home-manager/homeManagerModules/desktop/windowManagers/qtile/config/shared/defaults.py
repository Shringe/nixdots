from shared.keyboard.KeyboardLayout import KeyboardLayout
from dataclasses import dataclass
from os.path import expanduser


@dataclass(frozen=True)
class DefaultApplications:
    # terminal: str = "alacritty"
    terminal: str = "wezterm"
    # browser: str = "librewolf"
    browser: str = "firefox"
    music_player: str = "termusic"
    file_manager: str = "ranger"


mod = "mod4"
keyboard = KeyboardLayout("colemak_dh")

apps = DefaultApplications()

theme_dir: str = expanduser("~/.config/qtile/shared/themes")
