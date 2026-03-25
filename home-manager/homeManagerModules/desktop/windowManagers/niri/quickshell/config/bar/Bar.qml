import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Niri
import "../.."
import "../Data" as Dat
import "utils"
import "separators"
import "widgets"
import ".."

PanelWindow {
    id: root
    WlrLayershell.layer: root.dropdown.revealed ? WlrLayer.Overlay : WlrLayer.Top

    required property var modelData
    readonly property Rectangle bar: bar
    readonly property Item barItem: barItem
    readonly property ShellScreen output: modelData
    property bool laptop: false
    property bool onBottom: true
    property QtObject dropdown: QtObject {
        property bool revealed: false
        property var owner: null
        property int x: 0
        property int y: 0
        property int height: 0
        property int width: 0
    }

    screen: output
    anchors {
        top: !onBottom
        bottom: onBottom
        left: true
        right: true
    }

    color: "transparent"
    implicitHeight: screen.height
    // this reserves the space for the bar
    exclusiveZone: bar.visible ? bar.height : 0

    mask: Region {
        regions: [
            Region {
                item: bar
            },
            Region {
                item: root.dropdown.revealed && root.dropdown.owner ? root.dropdown.owner.dropdownItem : null
            }
        ]
    }

    Rectangle {
        id: bar
        y: root.onBottom ? root.screen.height - bar.height : 0
        implicitWidth: root.screen.width
        implicitHeight: 24
        color: Config.colors.base00

        bottomLeftRadius: root.onBottom ? 0 : Config.borders.radius
        bottomRightRadius: root.onBottom ? 0 : Config.borders.radius
        topLeftRadius: root.onBottom ? Config.borders.radius : 0
        topRightRadius: root.onBottom ? Config.borders.radius : 0

        Item {
            id: barItem
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5

            // Left
            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                spacing: 5
                SystemTray {
                    trunk: root
                }
                LeftSeparator {}
                WindowTitle {}
                LeftSeparator {}
            }

            // Center
            Workspaces {
                id: workspaces
                anchors.centerIn: parent
            }

            // Right
            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                spacing: 5

                RightSeparator {}
                TextButton {
                    text: "Night"
                    verticalPadding: 1
                    onClicked: Dat.NightLight.toggle()
                }
                RightSeparator {}
                Audio {
                    trunk: root
                    boxParent: workspaces
                }
                RightSeparator {}
                HardwareMonitor {
                    laptop: root.laptop
                }
                RightSeparator {}
                Clock {
                    id: clock
                    trunk: root
                }
            }
        }

        DynamicFrame {
            trunk: root
        }
    }
}
