import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Shapes
import "../.."
import "../../.."
import ".."
import "../utils"
import "../../Data" as Dat

DropDown {
    id: dropdown

    onOpenChanged: if (!open)
        isPreviewing = false

    content: Component {
        Tombstone {
            NotificationMenu {
                previewMode: dropdown.isPreviewing
            }
        }
    }

    Row {
        Connections {
            target: Dat.Notifications
            function onNotificationReceived(n) {
                if (Dat.Notifications.dndEnabled || dropdown.open)
                    return;
                const duration = ({
                        [NotificationUrgency.Low]: 2000,
                        [NotificationUrgency.Normal]: 5000,
                        [NotificationUrgency.Critical]: 10000
                    })[n.urgency] ?? 5000;
                dropdown.previewDisplay(duration);
            }
        }

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
