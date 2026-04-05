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
            output: modelData
            laptop: root.laptop
        }
        Wallpaper {
            output: modelData.name
            fps: root.fps
            name: root.wallpaper
        }
    }
}
