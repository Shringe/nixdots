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
    exclusiveZone: bar.visible ? bar.height + 0 : 0
    // implicitHeight: 24

    Rectangle {
        id: bar
        y: 0
        implicitWidth: root.screen.width
        implicitHeight: 24
        width: root.screen.width
        height: 24
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
