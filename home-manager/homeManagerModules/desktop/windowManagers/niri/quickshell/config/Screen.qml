import Quickshell
import "bar"

Variants {
    required property string output
    required property string wallpaper

    model: Quickshell.screens.filter(s => s.name === output)

    Scope {
        required property ShellScreen modelData
        Bar {
            output: modelData
        }
        Wallpaper {
            output: modelData
            name: wallpaper
        }
    }
}
