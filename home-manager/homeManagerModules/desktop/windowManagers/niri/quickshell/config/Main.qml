import Quickshell
import QtQuick
import Niri
import ".."
import "bar"
import "Data" as Dat

ShellRoot {
    Variants {
        model: Quickshell.screens.filter(s => s.name === "eDP-1")
        Bar {
            screen: Quickshell.screens.find(s => s.name === "eDP-1")
        }
    }
    Variants {
        model: Quickshell.screens.filter(s => s.name === "eDP-1")
        Wallpaper {
            screen: Quickshell.screens.find(s => s.name === "eDP-1")
            name: "PurpleFluid_1920x1080.png"
        }
    }

    Variants {
        model: Quickshell.screens.filter(s => s.name === "DP-1")
        Bar {
            screen: Quickshell.screens.find(s => s.name === "DP-1")
        }
    }
    Variants {
        model: Quickshell.screens.filter(s => s.name === "DP-1")
        Wallpaper {
            screen: Quickshell.screens.find(s => s.name === "DP-1")
            name: "2b_nier_automata_2560x1440.png"
        }
    }

    Variants {
        model: Quickshell.screens.filter(s => s.name === "HDMI-A-1")
        Bar {
            screen: Quickshell.screens.find(s => s.name === "HDMI-A-1")
        }
    }
    Variants {
        model: Quickshell.screens.filter(s => s.name === "HDMI-A-1")
        Wallpaper {
            screen: Quickshell.screens.find(s => s.name === "HDMI-A-1")
            name: "grassmastersword_3440x1440.png"
        }
    }
}
