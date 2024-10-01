from shared.defaults import DefaultApplications
from dataclasses import dataclass
from shared.utils.format import get_theme


theme = get_theme("zelda-adapta")


@dataclass(frozen=True)
class X11Applications(DefaultApplications):
    screenshot = "flameshot gui"
    launcher = "rofi -show drun"


apps = X11Applications()
