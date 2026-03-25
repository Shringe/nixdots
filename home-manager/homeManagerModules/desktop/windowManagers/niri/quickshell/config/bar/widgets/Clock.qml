import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import "../.."
import "../../.."
import ".."
import "../utils"
import "../../Data" as Dat

Row {
    id: root

    required property PanelWindow trunk

    Dropdown {
        id: dropdown
        trunk: root.trunk
        boxParent: root
        debugName: "Clockdown"

        Rectangle {
            color: Config.colors.base00
            radius: Config.borders.radius
            width: menu.width
            height: menu.height
            NotificationMenu {
                id: menu
                trunk: root.trunk
            }
        }
    }

    Connections {
        target: Dat.Notifications
        function onNotificationReceived(n) {
            if (Dat.Notifications.dndEnabled || trunk.output !== Dat.Session.currentScreen)
                return;
            const duration = ({
                    [NotificationUrgency.Low]: 2000,
                    [NotificationUrgency.Normal]: 5000,
                    [NotificationUrgency.Critical]: 10000
                })[n.urgency] ?? 5000;
            dropdown.propOpen(duration);
        }
    }

    WrapperMouseArea {
        id: mouseArea
        hoverEnabled: true

        onEntered: {
            dropdown.open();
        }

        onExited: {
            dropdown.close();
        }

        Row {
            // TODO: switch to quickshell Clock service
            Timer {
                interval: 1000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    const now = new Date();
                    datePart.text = Qt.formatDateTime(now, "ddd dd MMM");
                    timePart.text = Qt.formatDateTime(now, "hh:mm AP");
                }
            }

            Stext {
                text: Dat.Notifications.notifCount
            }

            TextIcon {
                icon: ""
                lpad: 5
                rpad: 8
            }

            Stext {
                id: datePart
            }

            TextIcon {
                icon: ""
                lpad: 7
                rpad: 8
            }

            Stext {
                id: timePart
            }

            TextIcon {
                icon: ""
                lpad: 7
                rpad: 2
            }
        }
    }
}
