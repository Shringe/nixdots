import Quickshell

import qs.inner
import qs.inner.Data as Dat

ShellRoot {
    Screen {
        output: "eDP-1"
        fps: 60
        // wallpaper: "PurpleFluid_1920x1080.png"
        wallpaper: "video/Blue_1920x1080.webp"
        laptop: true
    }

    Screen {
        output: "DP-1"
        fps: 165
        // wallpaper: "2b_nier_automata_2560x1440.png"
        // wallpaper: "video/Fragments.gif"
        // wallpaper: "video/Full of Hopes.gif"
        wallpaper: "collections/DP-1.json"
        // wallpaper: "collections/simple.json"
    }

    Screen {
        output: "HDMI-A-1"
        fps: 175
        // wallpaper: "grassmastersword_3440x1440.png"
        // wallpaper: "video/35.6541693, 139.gif"
        // wallpaper: "collections/simple.json"
        wallpaper: "collections/HDMI-A-1.json"
    }
}
