import Quickshell
import "bar"

Variants {
    id: root

    required property string output
    required property string wallpaper
    property bool laptop: false

    model: Quickshell.screens.filter(s => s.name === output)

    Scope {
        required property ShellScreen modelData
        Bar {
            output: root.modelData
            laptop: root.laptop
        }
        Wallpaper {
            output: root.modelData
            name: root.wallpaper
        }
    }
}
