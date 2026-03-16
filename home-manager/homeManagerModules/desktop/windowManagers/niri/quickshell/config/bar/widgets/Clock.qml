import QtQuick
import "../.."
import ".."
import "../utils"

Row {
    anchors.verticalCenter: parent.verticalCenter

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date();
            datePart.text = Qt.formatDateTime(now, "ddd dd MMM");
            timePart.text = Qt.formatDateTime(now, "hh:mm AP");
        }
    }

    Stext {
        id: datePart
    }

    TextIcon {
        icon: ""
        lpad: 7
        rpad: 5
    }

    Stext {
        id: timePart
    }

    TextIcon {
        icon: ""
        lpad: 7
        rpad: 3
    }
}
