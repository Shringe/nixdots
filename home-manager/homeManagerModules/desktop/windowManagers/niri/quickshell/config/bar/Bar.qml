import Quickshell
import QtQuick
import Niri
import "../.."

PanelWindow {
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

        WindowTitle {
            niri: niri
        }
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

        // todo
    }
}
