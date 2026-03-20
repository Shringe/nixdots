import QtQuick
import Quickshell
import "../Data" as Dat
import "../.."
import "../bar/utils"

Scope {
    id: root

    // 0 => disabled
    // 1 => pipewire sink
    // 2 => pipewire source
    // 3 => mpris player
    property int indicator: 0

    function display(indicator: int) {
        root.indicator = indicator;
        hideTimer.restart();
    }

    Connections {
        target: Dat.Pipewire
        function onSinkVolumeChanged() {
            display(1);
        }
        function onSinkMutedChanged() {
            display(1);
        }
        function onSourceVolumeChanged() {
            display(2);
        }
        function onSourceMutedChanged() {
            display(2);
        }
    }

    Connections {
        target: Dat.Mpris
        function onVolumeChanged() {
            display(3);
        }
        function onIsPlayingChanged() {
            display(3);
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.indicator = 0
    }

    LazyLoader {
        active: root.indicator != 0

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
                            icon: root.indicator == 2 ? Dat.Pipewire.sourceIcon : root.indicator == 3 ? Dat.Mpris.icon : Dat.Pipewire.sinkIcon
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
                            color: (root.indicator == 3 ? false : root.indicator == 2 ? Dat.Pipewire.sourceMuted : Dat.Pipewire.sinkMuted) ? Config.colors.base02 : Config.colors.base04

                            Rectangle {
                                anchors.left: parent.left
                                radius: parent.radius
                                implicitHeight: parent.implicitHeight
                                implicitWidth: parent.width * (root.indicator == 3 ? Dat.Mpris.volume : root.indicator == 2 ? Dat.Pipewire.sourceVolume : Dat.Pipewire.sinkVolume)
                                color: (root.indicator == 3 ? false : root.indicator == 2 ? Dat.Pipewire.sourceMuted : Dat.Pipewire.sinkMuted) ? Config.colors.base03 : Config.colors.base05
                            }
                        }
                    }
                }
            }
        }
    }
}
