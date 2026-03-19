import Quickshell
import Quickshell.Wayland
import QtQuick
import Niri
import "../.."
import "../Data" as Dat
import "utils"
import "separators"
import "widgets"

PanelWindow {
    id: panelWindow
    // WlrLayershell.layer: WlrLayer.Overlay

    required property var modelData
    property bool laptop: false

    screen: modelData
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 24
    color: Config.colors.base00

    Niri {
        id: niri
        Component.onCompleted: connect()

        onConnected: console.debug("Connected to niri")
        onErrorOccurred: function (error) {
            console.error("Niri error:", error);
        }
    }

    // Left
    Row {
        spacing: 5
        anchors {
            left: parent.left
            leftMargin: 5
            verticalCenter: parent.verticalCenter
        }

        // panelWindow: panelWindow
        SystemTray {}
        LeftSeparator {}
        WindowTitle {
            niri: niri
        }
        LeftSeparator {}
    }

    // Center
    Workspaces {
        niri: niri
        anchors.centerIn: parent
    }

    // Right
    Row {
        spacing: 5
        anchors {
            right: parent.right
            rightMargin: 5
            verticalCenter: parent.verticalCenter
        }

        TextButton {
            text: "Night"
            verticalPadding: 4
            onClicked: Dat.NightLight.toggle()
        }

        RightSeparator {}
        Audio {}
        RightSeparator {}
        HardwareMonitor {
            laptop: laptop
        }
        RightSeparator {}
        Clock {}
    }
}
