import Quickshell
import QtQuick
import Niri
import "../.."
import "separators"
import "widgets"

PanelWindow {
    id: panelWindow

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 24
    color: Config.colors.base00
    // color: Config.colors.base08

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

        RightSeparator {}
        Audio {}
        RightSeparator {}
        HardwareMonitor {}
        RightSeparator {}
        Clock {}
    }
}
