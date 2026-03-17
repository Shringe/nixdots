import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Shapes
import "../.."
import "../../.."
import ".."
import "../utils"
import "../../Data" as Dat

DropDown {
    content: Component {
        Tombstone {
            NotificationMenu {}
        }
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
