from shared.keyboard.KeyboardLayout import KeyboardLayout
from dataclasses import dataclass
from os.path import expanduser


@dataclass(frozen=True)
class DefaultApplications:
    terminal: str = "alacritty"
    browser: str = "librewolf"
    music_player: str = "termusic"
    file_manager: str = "ranger"


mod = "mod4"
keyboard = KeyboardLayout("colemak")

apps = DefaultApplications()

theme_dir: str = expanduser("~/.config/qtile/shared/themes")
