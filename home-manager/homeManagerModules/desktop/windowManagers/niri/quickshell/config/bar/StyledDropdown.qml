import QtQuick
import Quickshell
import Quickshell.Widgets

import qs

Item {
    id: root

    required property PanelWindow trunk
    required property Item triggerContent
    required property Item dropdownContent
    property Item boxParent: _mouseArea
    property int padding: Config.borders.radius
    property int horizontalPadding: root.padding
    property int verticalPadding: root.padding
    property alias mouseArea: _mouseArea
    property alias dropdown: _dropdown

    onTriggerContentChanged: triggerContent.parent = _mouseArea
    onDropdownContentChanged: {
        dropdownContent.parent = box;
        dropdownContent.anchors.centerIn = box;
    }

    implicitWidth: _mouseArea.implicitWidth
    implicitHeight: _mouseArea.implicitHeight

    WrapperMouseArea {
        id: _mouseArea
        hoverEnabled: true
        onEntered: _dropdown.open()
        onExited: _dropdown.close()
    }

    Dropdown {
        id: _dropdown
        trunk: root.trunk
        boxParent: root.boxParent

        Rectangle {
            id: box
            width: root.dropdownContent.width + root.horizontalPadding
            height: root.dropdownContent.height + root.verticalPadding
            color: Config.colors.base00
            radius: Config.borders.radius
        }
    }
}
