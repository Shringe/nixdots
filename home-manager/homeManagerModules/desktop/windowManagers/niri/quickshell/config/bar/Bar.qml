import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Niri
import "../.."
import "../Data" as Dat
import "../Shaders" as Shaders
import "utils"
import "separators"
import "widgets"
import ".."

PanelWindow {
    id: root

    // We switch to Wlr.Overlay when a dropdown is shown so that it will be drawn over any potential fullscreen window
    WlrLayershell.layer: revealedDropdowns.length > 0 ? WlrLayer.Overlay : WlrLayer.Top

    readonly property Rectangle bar: bar
    readonly property Item barItem: barItem
    required property ShellScreen output
    required property bool laptop
    property bool onBottom: false

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

    // Dropdowns should register themselves here
    property var dropdowns: []
    property var revealedDropdowns: {
        const out = dropdowns.filter(d => d.revealed);
        regionMask.regions = [barRegion, ...out.map(d => d.region)];
        return out;
    }

    Region {
        id: barRegion
        item: bar
    }

    mask: Region {
        id: regionMask
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

        DynamicFrame {
            trunk: root
        }

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
                output: root.output.name
            }

            // Right
            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                spacing: 5

                TextButton {
                    text: "Idle"
                    verticalPadding: 1
                    onClicked: Dat.Idle.toggleInhibit()
                    label.layer.enabled: true
                    label.layer.effect: Shaders.TwoColorAnimatedGradient {
                        enabled: Dat.Idle.inhibiting
                        src: Config.colors.glsl.base07
                        // dst: Config.colors.glsl.base0A
                    }
                }
                TextButton {
                    text: "Night"
                    verticalPadding: 1
                    onClicked: Dat.NightLight.toggle()
                }
                RightSeparator {
                    visible: Dat.Privacy.anyPrivacyActive
                }
                PrivacyIndicator {
                    trunk: root
                    visible: Dat.Privacy.anyPrivacyActive
                }
                RightSeparator {}
                Audio {
                    trunk: root
                    boxParent: workspaces
                }
                RightSeparator {}
                HardwareMonitor {
                    trunk: root
                }
                RightSeparator {}
                Clock {
                    id: clock
                    trunk: root
                }
            }
        }
    }
}
