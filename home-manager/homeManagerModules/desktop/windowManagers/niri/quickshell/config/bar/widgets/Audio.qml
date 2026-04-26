import QtQuick
import Quickshell
import Quickshell.Widgets
import ".."
import "../.."
import "../../.."
import "../../Data" as Dat
import "../utils"
import qs.inner.bar.widgets.VolumeOsd
import qs.inner.Shaders as Shaders

Row {
    id: root
    anchors.verticalCenter: parent.verticalCenter
    required property PanelWindow trunk
    required property var boxParent

    Dropdown {
        id: dropdown
        trunk: root.trunk
        boxParent: root.boxParent
        yOffset: trunk.onBottom ? 1 : -2
        onBottom: true

        VolumeOsd {
            id: osd
            trunk: root.trunk
            onDisplay: ind => {
                if (trunk.output === Dat.Session.currentScreen) {
                    osd.indicator = ind;
                    dropdown.propOpen(1500);
                } else {
                    dropdown.close();
                    osd.indicator = 0;
                }
            }
        }
    }

    WrapperMouseArea {
        anchors.verticalCenter: parent.verticalCenter
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.BackButton | Qt.ForwardButton
        onClicked: event => {
            if (event.button === Qt.LeftButton)
                Dat.Mpris.playPause();
            else if (event.button === Qt.RightButton)
                Dat.Mpris.stop();
            else if (event.button === Qt.BackButton)
                Dat.Mpris.prev();
            else if (event.button === Qt.ForwardButton)
                Dat.Mpris.next();
        }
        onWheel: event => Dat.Mpris.wheelAction(event)

        Row {
            Stext {
                text: Dat.Mpris.trackTitle
                visible: Dat.Mpris.trackHasTitle
                layer.enabled: true
                layer.effect: Shaders.TwoColorAnimatedGradient {
                    enabled: Dat.Mpris.isPlaying
                    angle: 180
                    src: Config.colors.glsl.base09
                    dst: Config.colors.glsl.base0A
                }
            }
        }
    }

    Spacer {
        width: Dat.Mpris.trackHasTitle ? 8 : 4
    }

    Cava {}

    Spacer {
        width: 8
    }

    WrapperMouseArea {
        anchors.verticalCenter: parent.verticalCenter
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.RightButton
        onClicked: Dat.Pipewire.toggleMute(Dat.Pipewire.sink)
        onWheel: event => Dat.Pipewire.wheelAction(event, Dat.Pipewire.sink)

        Row {
            anchors.verticalCenter: parent.verticalCenter

            Stext {
                text: Math.round(Dat.Pipewire.sinkVolume * 100) + "%"
            }
            TextIcon {
                icon: Dat.Pipewire.sinkIcon
                lpad: 4
            }
        }
    }

    Spacer {
        width: 8
    }

    WrapperMouseArea {
        anchors.verticalCenter: parent.verticalCenter
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.RightButton
        onClicked: Dat.Pipewire.toggleMute(Dat.Pipewire.source)
        onWheel: event => Dat.Pipewire.wheelAction(event, Dat.Pipewire.source)

        Row {
            anchors.verticalCenter: parent.verticalCenter

            Stext {
                text: Math.round(Dat.Pipewire.sourceVolume * 100) + "%"
            }
            TextIcon {
                icon: Dat.Pipewire.sourceIcon
                lpad: 4
                label.layer.enabled: true
                label.layer.effect: Shaders.TwoColorAnimatedGradient {
                    enabled: Dat.Privacy.microphoneActive
                    src: Config.colors.glsl.base0A
                    dst: Config.colors.glsl.base08
                }
            }
        }
    }
}
