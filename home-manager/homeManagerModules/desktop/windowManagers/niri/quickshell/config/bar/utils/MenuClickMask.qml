import Quickshell.Wayland
import Quickshell
import QtQuick

PanelWindow {
    signal closeRequested

    color: "transparent"

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    MouseArea {
        anchors.fill: parent
        focus: true // grab keyboard focus
        onClicked: closeRequested()
        Keys.onEscapePressed: closeRequested()
    }
}
