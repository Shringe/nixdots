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

    required property PanelWindow panelWindow
    property var openPopup: null

    Repeater {
        model: ScriptModel {
            values: [...SystemTray.items.values].reverse()
        }

        Item {
            required property SystemTrayItem modelData

            anchors.verticalCenter: parent.verticalCenter
            width: 16
            height: 16

            PopupWindow {
                id: menuPopup
                color: Config.colors.base00
                implicitWidth: 200
                implicitHeight: trayMenuContent.height
                anchor.window: panelWindow
                anchor.rect.x: 0
                anchor.rect.y: panelWindow.height

                onVisibleChanged: {
                    if (visible) {
                        if (parent.openPopup && parent.openPopup !== menuPopup)
                            parent.openPopup.visible = false;
                        parent.openPopup = menuPopup;
                        trayMenuContent.menu = null;
                        trayMenuContent.menu = modelData.menu;
                    } else {
                        if (parent.openPopup === menuPopup)
                            parent.openPopup = null;
                    }
                }

                TrayMenu {
                    id: trayMenuContent
                    width: 200
                    menu: modelData.menu
                }
            }

            WrapperMouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: event => {
                    if (event.button === Qt.LeftButton)
                        modelData.activate();
                    else
                        menuPopup.visible = !menuPopup.visible;
                }

                IconImage {
                    anchors.fill: parent
                    source: modelData.icon
                }
            }
        }
    }
}
