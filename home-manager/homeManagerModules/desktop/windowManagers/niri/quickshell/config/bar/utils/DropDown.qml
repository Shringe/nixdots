import QtQuick
import Quickshell
import Quickshell.Widgets

Item {
    default property alias triggerChildren: mouseArea.children
    property Component content
    property bool open: false
    property int menuButton: Qt.LeftButton
    property int xOffset: 0
    property int yOffset: 22
    property bool isPreviewing: false
    property int previewDuration: 2000
    signal activated

    implicitWidth: mouseArea.implicitWidth
    implicitHeight: mouseArea.implicitHeight

    function previewDisplay(duration) {
        isPreviewing = true;
        open = true;
        previewTimer.interval = duration ?? previewDuration;
        previewTimer.restart();
    }

    Timer {
        id: previewTimer
        interval: previewDuration
        onTriggered: open = false
    }

    MenuClickMask {
        visible: open && !isPreviewing
        onCloseRequested: {
            previewTimer.stop();
            isPreviewing = false;
            open = false;
        }
    }

    WrapperMouseArea {
        id: mouseArea
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: event => {
            previewTimer.stop();
            if (event.button === menuButton)
                open = !open;
            else
                activated();
        }
    }

    PopupWindow {
        visible: open
        color: "transparent"

        anchor.rect.x: xOffset
        anchor.rect.y: yOffset
        anchor.item: mouseArea

        implicitWidth: container.implicitWidth
        implicitHeight: container.implicitHeight

        Loader {
            id: container
            sourceComponent: content
        }
    }
}
