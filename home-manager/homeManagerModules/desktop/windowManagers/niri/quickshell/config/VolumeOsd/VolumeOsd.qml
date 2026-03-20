import QtQuick
import Quickshell
import "../Data" as Dat
import "../.."
import "../bar/utils"

Scope {
    id: root

    property bool shouldShowOsd: false
    property bool isSource: false

    Connections {
        target: Dat.Pipewire
        function onVolumeUpdate(isSource: bool) {
            root.isSource = isSource;
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
                            icon: Dat.Pipewire.sinkIcon
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
                            color: (root.isSource ? Dat.Pipewire.sourceMuted : Dat.Pipewire.sinkMuted) ? Config.colors.base02 : Config.colors.base04

                            Rectangle {
                                anchors.left: parent.left
                                radius: parent.radius
                                implicitHeight: parent.implicitHeight
                                implicitWidth: parent.width * (root.isSource ? Dat.Pipewire.sourceVolume : Dat.Pipewire.sinkVolume)
                                color: (root.isSource ? Dat.Pipewire.sourceMuted : Dat.Pipewire.sinkMuted) ? Config.colors.base03 : Config.colors.base05
                            }
                        }
                    }
                }
            }
        }
    }
}
