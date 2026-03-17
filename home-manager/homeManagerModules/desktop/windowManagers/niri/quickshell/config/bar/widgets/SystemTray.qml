pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import ".."
import "../.."
import "../../.."
import "../utils"

Row {
    anchors.verticalCenter: parent.verticalCenter
    spacing: 6

    property DropDown openDropDown: null

    Repeater {
        model: ScriptModel {
            values: [...SystemTray.items.values].reverse()
        }

        DropDown {
            required property SystemTrayItem modelData
            property var itemMenu: modelData.menu

            anchors.verticalCenter: parent.verticalCenter
            xOffset: -1000
            yOffset: 20

            menuButton: Qt.RightButton
            onActivated: modelData.activate()

            onOpenChanged: {
                if (open) {
                    if (parent.openDropDown && parent.openDropDown !== this)
                        parent.openDropDown.open = false;
                    parent.openDropDown = this;
                } else if (parent.openDropDown === this)
                    parent.openDropDown = null;
            }

            content: Component {
                Tombstone {
                    TrayMenu {
                        width: 300
                        menu: itemMenu
                    }
                }
            }

            IconImage {
                implicitWidth: 16
                implicitHeight: 16
                source: modelData.icon
            }
        }
    }
}
