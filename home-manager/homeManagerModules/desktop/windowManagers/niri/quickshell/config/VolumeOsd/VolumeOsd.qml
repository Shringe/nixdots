import QtQuick
import Quickshell
import "../Data" as Dat
import "../.."
import ".."
import "../bar/utils"

Scope {
    id: root

    // 0 => disabled
    // 1 => pipewire sink
    // 2 => pipewire source
    // 3 => mpris volume
    // 4 => mpris track or playback
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
            display(4);
        }
        function onTrackTitleChanged() {
            display(4);
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.indicator = 0
    }

    LazyLoader {
        active: root.indicator == 1 || root.indicator == 2 || root.indicator == 3

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
                            icon: root.indicator == 3 ? Dat.Mpris.icon : root.indicator == 2 ? Dat.Pipewire.sourceIcon : Dat.Pipewire.sinkIcon
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

    LazyLoader {
        active: root.indicator == 4

        PanelWindow {
            id: trackPanel

            anchors.bottom: true
            margins.bottom: screen.height / 6
            exclusiveZone: 0

            // Rough estimation of text length
            implicitWidth: Math.max(200, Math.min(screen.width / 4, Dat.Mpris.trackTitle.length * 11 + 80))
            implicitHeight: 60
            color: "transparent"

            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: 6
                color: Config.colors.base00
                border.color: Config.colors.base07
                border.width: 2

                Row {
                    Item {
                        width: 60
                        height: trackPanel.height
                        TextIcon {
                            anchors.centerIn: parent
                            icon: Dat.Mpris.icon
                            label.font.pixelSize: 40
                        }
                    }

                    Item {
                        width: trackPanel.width - 60
                        height: trackPanel.height

                        Stext {
                            id: trackText
                            anchors.centerIn: parent
                            width: parent.width - 20
                            text: Dat.Mpris.trackTitle
                            font.pixelSize: 16
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }
}
