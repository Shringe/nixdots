import QtQuick
import Quickshell
import "../Data" as Dat
import "../.."
import "../bar/utils"

Scope {
    id: root

    property bool shouldShowOsd: false
    property real volume
    property string icon
    property bool isMuted

    Connections {
        target: Dat.Pipewire
        function onVolumeUpdate(volume: real, icon: string, isMuted: bool, isSource: bool) {
            root.volume = volume;
            root.icon = icon;
            root.isMuted = isMuted;
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            id: panel

            anchors.bottom: true
            margins.bottom: screen.height / 6
            exclusiveZone: 0

            implicitWidth: 250
            implicitHeight: 60
            color: "transparent"

            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {}

            Rectangle {
                id: widget
                anchors.fill: parent
                radius: 6
                color: Config.colors.base00
                border.color: Config.colors.base07
                border.width: 2

                Row {
                    Item {
                        width: 60
                        height: panel.height
                        TextIcon {
                            anchors.centerIn: parent
                            icon: root.icon
                            label.font.pixelSize: 40
                        }
                    }

                    Item {
                        width: panel.width - 60
                        height: panel.height

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            radius: widget.radius
                            implicitHeight: 10
                            implicitWidth: panel.implicitWidth - 80
                            color: root.isMuted ? Config.colors.base02 : Config.colors.base04

                            Rectangle {
                                anchors.left: parent.left
                                radius: parent.radius
                                implicitHeight: parent.implicitHeight
                                implicitWidth: parent.width * root.volume
                                color: root.isMuted ? Config.colors.base03 : Config.colors.base05
                            }
                        }
                    }
                }
            }
        }
    }
}
