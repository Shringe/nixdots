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
    signal activated

    implicitWidth: mouseArea.implicitWidth
    implicitHeight: mouseArea.implicitHeight

    MenuClickMask {
        visible: open
        onCloseRequested: open = false
    }

    WrapperMouseArea {
        id: mouseArea
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: event => {
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
