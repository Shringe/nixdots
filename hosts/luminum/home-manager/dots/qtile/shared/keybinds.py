from libqtile.config import Key, Drag, Click
from libqtile.lazy import lazy
from shared.defaults import keyboard, mod


keys: list = []


# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]


# A list of available commands that can be bound to keys can be found
# at https://docs.qtile.org/en/latest/manual/config/lazy.html
wmControls = [
    # Switch between windows
    keyboard.Key(
        [mod],
        "j",
        lazy.layout.left(),
        desc="Move focus to left",
    ),
    keyboard.Key(
        [mod],
        "k",
        lazy.layout.down(),
        desc="Move focus down",
    ),
    keyboard.Key([mod], "l", lazy.layout.up(), desc="Move focus up"),
    keyboard.Key(
        [mod],
        ";",
        lazy.layout.right(),
        desc="Move focus to right",
    ),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    keyboard.Key(
        [mod, "shift"],
        "j",
        lazy.layout.shuffle_left(),
        desc="Move window to the left",
    ),
    keyboard.Key(
        [mod, "shift"],
        "k",
        lazy.layout.shuffle_down(),
        desc="Move window down",
    ),
    keyboard.Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_up(),
        desc="Move window up",
    ),
    keyboard.Key(
        [mod, "shift"],
        ";",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    keyboard.Key(
        [mod, "control"],
        "j",
        lazy.layout.grow_left(),
        desc="Grow window to the left",
    ),
    keyboard.Key(
        [mod, "control"],
        "k",
        lazy.layout.grow_down(),
        lazy.layout.shrink().when(layout=("monadtall", "monadwide", "monadthreecol")),
        desc="Grow window down",
    ),
    keyboard.Key(
        [mod, "control"],
        "l",
        lazy.layout.grow_up(),
        desc="Grow window up",
    ),
    keyboard.Key(
        [mod, "control"],
        ";",
        lazy.layout.grow_right(),
        desc="Grow window to the right",
    ),
    # same thing with arrow keys
    keyboard.Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    keyboard.Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    keyboard.Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),
    keyboard.Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    keyboard.Key(
        [mod, "shift"],
        "Left",
        lazy.layout.shuffle_left(),
        desc="Move window to the left",
    ),
    keyboard.Key(
        [mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"
    ),
    keyboard.Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    keyboard.Key(
        [mod, "shift"],
        "Right",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    keyboard.Key(
        [mod, "control"],
        "Left",
        lazy.layout.grow_left(),
        desc="Grow window to the left",
    ),
    keyboard.Key(
        [mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"
    ),
    keyboard.Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    keyboard.Key(
        [mod, "control"],
        "Right",
        lazy.layout.grow_right(),
        desc="Grow window to the right",
    ),
]
qtile = [
    keyboard.Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    keyboard.Key(
        [mod],
        "w",
        lazy.window.kill(),
        desc="Kill focused window",
    ),
    keyboard.Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    keyboard.Key(
        [mod],
        "space",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    keyboard.Key(
        [mod, "control"],
        "r",
        lazy.reload_config(),
        desc="Reload the config",
    ),
    keyboard.Key(
        [mod, "control"],
        "q",
        lazy.shutdown(),
        desc="Shutdown Qtile",
    ),
]
media = [
    keyboard.Key([], "XF86AudioPlay", lazy.spawn("media-control play_pause")),
    keyboard.Key([], "XF86AudioNext", lazy.spawn("media-control next")),
    keyboard.Key([], "XF86AudioPrev", lazy.spawn("media-control prev")),
    keyboard.Key([], "XF86AudioRaiseVolume", lazy.spawn("media-control volume_up")),
    keyboard.Key([], "XF86AudioLowerVolume", lazy.spawn("media-control volume_down")),
    keyboard.Key([], "XF86AudioMute", lazy.spawn("media-control volume_mute")),
    keyboard.Key(
        ["control"], "XF86AudioRaiseVolume", lazy.spawn("media-control mic_up")
    ),
    keyboard.Key(
        ["control"], "XF86AudioLowerVolume", lazy.spawn("media-control mic_down")
    ),
    keyboard.Key(["control"], "XF86AudioMute", lazy.spawn("media-control mic_mute")),
]
scratchpad_group: str = "0"
scratchpads = [
    keyboard.Key([mod], "n", lazy.group[scratchpad_group].dropdown_toggle("terminal")),
    keyboard.Key([mod], "m", lazy.group[scratchpad_group].dropdown_toggle("music")),
    keyboard.Key([mod], 48, lazy.group[scratchpad_group].dropdown_toggle("files")),
]

keys.extend(wmControls)
keys.extend(qtile)
keys.extend(media)
keys.extend(scratchpads)
