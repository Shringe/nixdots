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
    layoutDirection: Qt.RightToLeft

    required property PanelWindow trunk
    property Dropdown lastDropdown: null

    Repeater {
        model: SystemTray.items

        StyledDropdown {
            required property SystemTrayItem modelData
            trunk: root.trunk

            triggerContent: IconImage {
                implicitWidth: 16
                implicitHeight: 16
                source: modelData.icon
            }

            dropdownContent: TrayMenu {
                width: 300
                menu: modelData.menu
            }

            mouseArea {
                acceptedButtons: Qt.LeftButton
                onEntered: {
                    if (root.lastDropdown && root.lastDropdown !== dropdown)
                        root.lastDropdown.close(0);
                    root.lastDropdown = dropdown;
                    dropdown.open();
                }
                onExited: dropdown.close()
                onClicked: modelData.activate()
            }
        }
    }
}
