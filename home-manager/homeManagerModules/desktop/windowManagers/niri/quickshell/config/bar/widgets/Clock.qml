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

    // Connections {
    //     target: Dat.Notifications
    //     function onNotificationReceived(n) {
    //         if (Dat.Notifications.dndEnabled || dropdown.open)
    //             return;
    //         const duration = ({
    //                 [NotificationUrgency.Low]: 2000,
    //                 [NotificationUrgency.Normal]: 5000,
    //                 [NotificationUrgency.Critical]: 10000
    //             })[n.urgency] ?? 5000;
    //         dropdown.previewDisplay(duration);
    //     }
    // }

    Dropdown {
        id: dashboard
        boxParent: root

        Rectangle {
            color: "red"
            implicitWidth: 180
            implicitHeight: 80

            ColumnLayout {
                anchors.fill: parent
                spacing: 4

                Stext {
                    text: "Volume"
                    color: Config.colors.base07
                    Layout.fillWidth: true
                }
            }
        }
    }

    WrapperMouseArea {
        id: mouseArea
        // cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onEntered: {
            dashboard.show = true;
            States.dashboardPresent = true;
        }

        onExited: {
            // do not close it right away
            dashboard.timer.start();
        }

        Row {
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
