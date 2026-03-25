import QtQuick
import Quickshell
import Quickshell.Wayland
import qs
import qs.inner
import qs.inner.bar.utils
import qs.inner.Data as Dat

// TODO: add brightness indicator
// TODO: add rust cli that functions like swayosd-client for lower latency indicator updates and nicer window manager keybinds

Item {
    id: root

    implicitWidth: (root.indicator == 1 || root.indicator == 2) ? widget.width : root.indicator == 3 ? trackWidget.width : 0
    implicitHeight: (root.indicator == 1 || root.indicator == 2) ? widget.height : root.indicator == 3 ? trackWidget.height : 0
    required property PanelWindow trunk

    // 0 => disabled
    // 1 => pipewire sink
    // 2 => pipewire source
    // 3 => mpris
    property int indicator: 0

    signal display(ind: int)

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

    Rectangle {
        id: widget
        width: 250
        height: 60
        radius: Config.borders.radius
        color: Config.colors.base00

        Row {
            visible: root.indicator == 1 || root.indicator == 2
            Item {
                width: 60
                height: widget.height
                TextIcon {
                    anchors.centerIn: parent
                    icon: root.indicator == 2 ? Dat.Pipewire.sourceIcon : Dat.Pipewire.sinkIcon
                    label.font.pixelSize: 40
                }
            }

            Item {
                width: widget.width - 60
                height: widget.height

                VolumeBar {
                    radius: widget.radius
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: widget.width - 80
                    volume: root.indicator == 3 ? Dat.Mpris.volume : root.indicator == 2 ? Dat.Pipewire.sourceVolume : Dat.Pipewire.sinkVolume
                    muted: root.indicator == 3 ? false : root.indicator == 2 ? Dat.Pipewire.sourceMuted : Dat.Pipewire.sinkMuted
                }
            }
        }
    }

    Rectangle {
        id: trackWidget
        readonly property string displayText: Dat.Mpris.artist + " - " + Dat.Mpris.trackTitle

        // Estimation of text length. This assumes your font's width is exactly 60% of its height, and that it is monospaced
        width: Math.max(200, Math.min(screen.width / 4, Math.ceil(displayText.length * trackText.font.pixelSize * 0.6) + 100))
        height: 60
        radius: Config.borders.radius
        color: Config.colors.base00
        visible: root.indicator == 3

        Row {
            Item {
                width: 60
                height: trackWidget.height
                TextIcon {
                    anchors.centerIn: parent
                    icon: Dat.Mpris.icon
                    label.font.pixelSize: 40
                }
            }

            Item {
                width: trackWidget.width - 60
                height: trackWidget.height

                Column {
                    anchors.centerIn: parent
                    spacing: 6

                    Stext {
                        id: trackText
                        width: trackWidget.width - 80
                        text: trackWidget.displayText
                        font.pixelSize: 18
                        elide: Text.ElideRight
                    }

                    VolumeBar {
                        radius: trackWidget.radius
                        implicitWidth: trackWidget.width - 100
                        volume: Dat.Mpris.volume
                    }
                }
            }
        }
    }
}
