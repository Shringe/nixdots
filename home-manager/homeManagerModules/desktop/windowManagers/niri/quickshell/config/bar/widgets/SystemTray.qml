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
    id: root
    anchors.verticalCenter: parent.verticalCenter
    spacing: 6

    required property PanelWindow trunk
    property Dropdown lastDropdown: null

    Repeater {
        model: ScriptModel {
            values: [...SystemTray.items.values].reverse()
        }

        Item {
            id: delegate
            required property SystemTrayItem modelData

            implicitWidth: iconButton.implicitWidth
            implicitHeight: iconButton.implicitHeight

            Dropdown {
                id: dropdown
                trunk: root.trunk
                boxParent: iconButton

                Rectangle {
                    color: Config.colors.base00
                    width: menu.width
                    height: menu.height
                    TrayMenu {
                        id: menu
                        width: 300
                        menu: delegate.modelData.menu
                    }
                }
            }

            WrapperMouseArea {
                id: iconButton
                acceptedButtons: Qt.LeftButton
                hoverEnabled: true

                onEntered: {
                    if (root.lastDropdown && root.lastDropdown !== dropdown)
                        root.lastDropdown.close(0);
                    root.lastDropdown = dropdown;
                    dropdown.open();
                }
                onExited: {
                    dropdown.close();
                }
                onClicked: mouse => {
                    delegate.modelData.activate();
                }

                IconImage {
                    implicitWidth: 16
                    implicitHeight: 16
                    source: delegate.modelData.icon
                }
            }
        }
    }
}
