import Quickshell
import QtQuick
import Niri

ShellRoot {
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 30
        color: "#1C1F22"

        Niri {
            id: niri
            Component.onCompleted: connect()

            onConnected: console.log("Connected to niri")
            onErrorOccurred: function (error) {
                console.error("Niri error:", error);
            }
        }

        // Limit to first 10 workspaces
        Component.onCompleted: niri.workspaces.maxCount = 10

        Row {
            spacing: 10
            anchors {
                left: parent.left
                leftMargin: 5
                verticalCenter: parent.verticalCenter
            }

            Row {
                spacing: 2

                Repeater {
                    model: niri.workspaces

                    Rectangle {
                        width: 30
                        height: 20
                        color: model.isFocused ? "#106DAA" : model.isActive ? "#377B86" : "#222225"
                        border.color: model.isUrgent ? "red" : "#16181A"
                        border.width: 2
                        radius: 3

                        Text {
                            anchors.centerIn: parent
                            text: model.name || model.index
                            font.family: "Barlow Medium"
                            color: model.isFocused || model.isActive ? "white" : "#89919A"
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: niri.focusWorkspaceById(model.id)
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }
            }

            Text {
                text: niri.focusedWindow?.title ?? ""
                font.family: "Barlow Medium"
                font.pixelSize: 16
                color: Colors.accent
            }
        }
    }
}
