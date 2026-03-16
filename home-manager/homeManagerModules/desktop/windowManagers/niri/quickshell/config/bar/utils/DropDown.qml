import QtQuick
import Quickshell
import Quickshell.Widgets

Item {
    default property alias triggerChildren: mouseArea.children
    property Component content
    property bool open: false

    implicitWidth: mouseArea.implicitWidth
    implicitHeight: mouseArea.implicitHeight

    WrapperMouseArea {
        id: mouseArea
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: open = !open
    }

    PopupWindow {
        visible: open
        anchor.rect.y: 24
        anchor.item: mouseArea

        implicitWidth: container.implicitWidth
        implicitHeight: container.implicitHeight

        Loader {
            id: container
            sourceComponent: content
        }
    }
}
