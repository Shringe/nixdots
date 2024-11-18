from shared import autostart

# Launches programs if not already running
launch_if_not_running = [
    "picom",
    "dunst",
    "kdeconnect-indicator",
    "greenclip daemon",
    "xidlehook --not-when-audio --not-when-fullscreen --timer 600 'betterlockscreen --off 60 -l' ''",  # lockscreen when inactive
    "openrgb --startminimized",
    "lxqt-policykit-agent",
    "unclutter",
]

# Restarts programs if already running
restart = []

# Launches only once after the system boots
launch_once = [
    "sudo overclock3070",
]

autostart.register(launch_once, launch_if_not_running, restart)
