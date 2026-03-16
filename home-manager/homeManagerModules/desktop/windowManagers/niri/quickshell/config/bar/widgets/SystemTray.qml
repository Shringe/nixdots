pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import ".."
import "../.."
import "../../.."

Row {
    anchors.verticalCenter: parent.verticalCenter
    spacing: 6

    Repeater {
        model: ScriptModel {
            values: [...SystemTray.items.values].reverse()
        }

        WrapperMouseArea {
            required property SystemTrayItem modelData

            anchors.verticalCenter: parent.verticalCenter
            width: 16
            height: 16

            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: event => {
                if (event.button === Qt.LeftButton)
                    modelData.activate();
                else
                    modelData.display(panelWindow, event.x, 24);
            }

            PopupWindow {}

            IconImage {
                anchors.fill: parent
                source: modelData.icon
            }
        }
    }
}
