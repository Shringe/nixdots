import QtQuick
import Quickshell
import Quickshell.Widgets
import ".."
import "../.."
import "../../.."
import "../../Data" as Dat
import "../utils"

Row {
    anchors.verticalCenter: parent.verticalCenter

    WrapperMouseArea {
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
            }
        }
    }
}
