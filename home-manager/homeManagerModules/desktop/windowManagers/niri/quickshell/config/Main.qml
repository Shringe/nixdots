import Quickshell

import qs.inner
import qs.inner.Data as Dat

ShellRoot {
    Screen {
        output: "eDP-1"
        fps: 60
        // wallpaper: "PurpleFluid_1920x1080.png"
        wallpaper: "video/wallpaper.webp"
        laptop: true
    }

    Screen {
        output: "DP-1"
        fps: 165
        wallpaper: "2b_nier_automata_2560x1440.png"
    }

    Screen {
        output: "HDMI-A-1"
        fps: 175
        wallpaper: "grassmastersword_3440x1440.png"
    }

    Stext {
        text: Dat.auto
    }
}
