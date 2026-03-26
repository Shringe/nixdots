import QtQuick
import Quickshell
import Quickshell.Widgets

import qs

Item {
    id: root

    required property PanelWindow trunk
    required property Item triggerContent
    required property Item dropdownContent

    onTriggerContentChanged: triggerContent.parent = mouseArea
    onDropdownContentChanged: {
        dropdownContent.parent = box;
        dropdownContent.anchors.centerIn = box;
    }

    implicitWidth: mouseArea.implicitWidth
    implicitHeight: mouseArea.implicitHeight

    WrapperMouseArea {
        id: mouseArea
        hoverEnabled: true
        onEntered: dropdown.open()
        onExited: dropdown.close()
    }

    Dropdown {
        id: dropdown
        trunk: root.trunk
        boxParent: mouseArea

        Rectangle {
            id: box
            width: root.dropdownContent.width + Config.borders.radius
            height: root.dropdownContent.height + Config.borders.radius
            color: Config.colors.base00
            radius: Config.borders.radius
        }
    }
}
