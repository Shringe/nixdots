import Quickshell
import QtQuick
import Niri
import ".."
import "bar"

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Component {
            Bar {}
        }
    }
}
