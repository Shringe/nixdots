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

PanelWindow {
    id: root
    // WlrLayershell.layer: WlrLayer.Overlay

    required property var modelData
    property bool laptop: false

    screen: modelData
    anchors {
        top: true
        left: true
        right: true
    }

    mask: itemsRegions
    color: "transparent"
    implicitHeight: screen.height
    // this reserves the space for the bar
    exclusiveZone: bar.visible ? bar.height : 0

    Rectangle {
        id: bar
        y: 0
        implicitWidth: root.screen.width
        implicitHeight: 24 + Config.borders.size
        width: root.screen.width
        color: Config.colors.base00
        radius: 0

        DynamicFrame {
            barWidth: bar.width
            barHeight: bar.height
        }

        Niri {
            id: niri
            Component.onCompleted: connect()

            onConnected: console.debug("Connected to niri")
            onErrorOccurred: function (error) {
                console.error("Niri error:", error);
            }
        }

        // iterates over all window components and
        // creates their regions
        Variants {
            id: regions
            model: root.contentItem.children

            delegate: Region {
                required property Item modelData
                item: modelData
            }
        }

        // regions for all window components
        Region {
            id: itemsRegions
            regions: regions.instances
        }

        Item {
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.bottomMargin: Config.borders.size

            // Left
            Row {
                anchors.left: parent.left
                spacing: 5
                SystemTray {}
                LeftSeparator {}
                WindowTitle {
                    niri: niri
                }
                LeftSeparator {}
            }

            // Center
            Workspaces {
                anchors.centerIn: parent
                niri: niri
            }

            // Right
            Row {
                anchors.right: parent.right
                spacing: 5

                TextButton {
                    text: "Night"
                    verticalPadding: 0
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
    }
}
