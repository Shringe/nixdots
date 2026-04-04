import Quickshell
import "bar"

Variants {
    id: root

    required property string output
    required property int fps
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
            fps: root.fps
            name: root.wallpaper
        }
    }
}
