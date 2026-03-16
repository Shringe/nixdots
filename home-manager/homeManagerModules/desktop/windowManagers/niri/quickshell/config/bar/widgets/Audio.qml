import QtQuick
import Quickshell
import Quickshell.Widgets
import ".."
import "../.."
import "../../.."
import "../utils"

Row {
    anchors.verticalCenter: parent.verticalCenter

    WrapperMouseArea {
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.RightButton
        onClicked: Pipewire.toggleMute(Pipewire.sink)
        onWheel: event => Pipewire.wheelAction(event, Pipewire.sink)

        Row {
            anchors.verticalCenter: parent.verticalCenter

            Stext {
                text: Math.round(Pipewire.sinkVolume * 100) + "%"
            }
            TextIcon {
                icon: Pipewire.sinkIcon
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
        onClicked: Pipewire.toggleMute(Pipewire.source)
        onWheel: event => Pipewire.wheelAction(event, Pipewire.source)

        Row {
            anchors.verticalCenter: parent.verticalCenter

            Stext {
                text: Math.round(Pipewire.sourceVolume * 100) + "%"
            }
            TextIcon {
                icon: Pipewire.sourceIcon
                lpad: 4
            }
        }
    }
}
