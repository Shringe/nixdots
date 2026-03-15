import QtQuick
import ".."

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

    Spacer {
        width: 7
    }

    Stext {
        text: ""
    }

    Spacer {
        width: 5
    }

    Stext {
        id: timePart
    }

    Spacer {
        width: 7
    }

    Stext {
        text: ""
    }

    Spacer {
        width: 3
    }
}
