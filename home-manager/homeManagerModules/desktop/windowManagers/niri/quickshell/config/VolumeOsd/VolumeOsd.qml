import QtQuick
import Quickshell
import Quickshell.Wayland
import "../Data" as Dat
import "../.."
import ".."
import "../bar/utils"

// TODO: add brightness indicator
// TODO: add rust cli that functions like swayosd-client for lower latency indicator updates and nicer window manager keybinds

Scope {
    id: root

    // 0 => disabled
    // 1 => pipewire sink
    // 2 => pipewire source
    // 3 => mpris
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
        function onTrackTitleChanged() {
            display(3);
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.indicator = 0
    }

    LazyLoader {
        active: root.indicator == 1 || root.indicator == 2

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
                            icon: root.indicator == 2 ? Dat.Pipewire.sourceIcon : Dat.Pipewire.sinkIcon
                            label.font.pixelSize: 40
                        }
                    }

                    Item {
                        width: panel.width - 60
                        height: panel.height

                        VolumeBar {
                            radius: widget.radius
                            anchors.verticalCenter: parent.verticalCenter
                            implicitWidth: panel.implicitWidth - 80
                            volume: root.indicator == 3 ? Dat.Mpris.volume : root.indicator == 2 ? Dat.Pipewire.sourceVolume : Dat.Pipewire.sinkVolume
                            muted: root.indicator == 3 ? false : root.indicator == 2 ? Dat.Pipewire.sourceMuted : Dat.Pipewire.sinkMuted
                        }
                    }
                }
            }
        }
    }

    LazyLoader {
        active: root.indicator == 3

        PanelWindow {
            id: trackPanel

            readonly property string displayText: Dat.Mpris.artist + " - " + Dat.Mpris.trackTitle

            anchors.bottom: true
            margins.bottom: screen.height / 6
            exclusiveZone: 0
            WlrLayershell.layer: WlrLayer.Overlay

            // Estimation of text length. This assumes your font's width is exactly 60% of its height, and that it is monospaced
            implicitWidth: Math.max(200, Math.min(screen.width / 4, Math.ceil(trackPanel.displayText.length * trackText.font.pixelSize * 0.6) + 100))
            implicitHeight: 60
            color: "transparent"

            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {}

            Rectangle {
                id: trackWidget
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

                        Column {
                            anchors.centerIn: parent
                            spacing: 6

                            Stext {
                                id: trackText
                                width: trackPanel.width - 80
                                text: trackPanel.displayText
                                font.pixelSize: 18
                                elide: Text.ElideRight
                            }

                            VolumeBar {
                                radius: trackWidget.radius
                                implicitWidth: trackPanel.implicitWidth - 100
                                volume: Dat.Mpris.volume
                            }
                        }
                    }
                }
            }
        }
    }
}
