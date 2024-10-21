from libqtile.lazy import lazy
from shared.utils.ToggleCommand import ToggleCommand
from shared.defaults import mod, keyboard
from x11.defaults import apps

music_player = [
    keyboard.Key(
        ["mod1"], "XF86AudioPlay", lazy.spawn(apps.music_player + " --play-pause")
    ),
    keyboard.Key(["mod1"], "XF86AudioNext", lazy.spawn(apps.music_player + " --next")),
    keyboard.Key(
        ["mod1"], "XF86AudioPrev", lazy.spawn(apps.music_player + " --previous")
    ),
    keyboard.Key(
        ["mod1"],
        "XF86AudioRaiseVolume",
        lazy.spawn(apps.music_player + " --volume-increase-by 3"),
    ),
    keyboard.Key(
        ["mod1"],
        "XF86AudioLowerVolume",
        lazy.spawn(apps.music_player + " --volume-decrease-by 3"),
    ),
    keyboard.Key(
        ["mod1"], "XF86AudioMute", lazy.spawn(apps.music_player + " --volume 0")
    ),
]

applications = [
    keyboard.Key([mod], "Return", lazy.spawn(apps.terminal), desc="Launch terminal"),
    keyboard.Key(
        [mod],
        str("d"),
        lazy.spawn(apps.launcher),
        desc="Launch launcher",
    ),
    keyboard.Key([], "Print", lazy.spawn(apps.screenshot), desc="Open screenshot tool"),
    keyboard.Key(
        [mod],
        str("s"),
        lazy.spawn(apps.browser),
        desc="Launch browser",
    ),
    keyboard.Key([mod], str("e"), lazy.spawn(apps.file_manager)),
]

menu = [
    keyboard.Key(
        [mod],
        ("g"),
        lazy.spawn("rofi -modi 'clipboard:greenclip print' -show clipboard"),
    ),
    keyboard.Key([mod], ("t"), lazy.spawn("rofi-nordvpn")),
    keyboard.Key([mod], ("b"), lazy.spawn("rofi-bluetooth")),
    keyboard.Key(
        [mod, "shift"],
        ("t"),
        lazy.spawn("rofi -show power-menu -modi power-menu:rofi-power-menu"),
    ),
    keyboard.Key(
        [mod],
        ("o"),
        lazy.spawn("rofi -modi emoji -show emoji"),
    ),
]

gsyncToggle = ToggleCommand("set-displays gsync", "set-displays")
redshiftToggle = ToggleCommand("redshift -O 2300", "redshift -x")
toggles = [
    keyboard.Key([], "XF86MonBrightnessDown", lazy.function(gsyncToggle.toggle)),
    keyboard.Key([], "XF86MonBrightnessUp", lazy.function(redshiftToggle.toggle)),
]


keys: list = []

keys.extend(music_player)
keys.extend(applications)
keys.extend(menu)
keys.extend(toggles)
