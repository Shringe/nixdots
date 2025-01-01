from libqtile import qtile, layout
from libqtile.lazy import lazy
from libqtile.config import Key
from libqtile.log_utils import logger

from shared import keybinds, layouts

# Core settings
# Anything left blank is to be set in x11/wayland functions instead
keys: list = keybinds.keys

mod: str = keybinds.mod
groups: list = layouts.groups
floating_layout = layouts.floating

follow_mouse_focus: bool = True
bring_front_click: bool = True
cursor_warp: bool = False

auto_fullscreen: bool = True
floats_kept_above: bool = True
focus_on_window_activation = "smart"
reconfigure_screens: bool = True
auto_minimize: bool = True

wmname: str = "LG3D"
# wmname: str = "QTile"

wl_input_rules: dict
wl_xcursor_theme: str
wl_xcursor_size: int

widget_defaults: dict
screens: list


def x11():
    from x11 import keybinds

    logger.setLevel("WARNING")
    # logger.setLevel("DEBUG")
    logger.info("Loading X11 config")

    # Importing hooks
    from x11 import rules
    from x11 import autostart

    # Core settings
    global widget_defaults, screens
    from x11.display.screens import screens, widget_defaults

    # Extending/Overwriting shared
    keys.extend(keybinds.keys)


def wayland():
    import wayland

    logger.setLevel("INFO")
    logger.info("Loading Wayland config")

    # Core settings
    global wl_input_rules, wl_xcursor_theme, wl_xcursor_size
    wl_input_rules = {}
    wl_xcursor_theme = ""
    wl_xcursor_size = 24

    x11()


match qtile.core.name:
    case "x11":
        x11()
    case "wayland":
        wayland()

# Group keybinds
for group in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                group.name,
                lazy.group[group.name].toscreen(),
                desc="Switch to group {}".format(group.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                group.name,
                lazy.window.togroup(group.name, switch_group=False),
                desc="Switch to & move focused window to group {}".format(group.name),
            ),
        ]
    )
