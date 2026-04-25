import QtQuick
import Quickshell
import Quickshell.Widgets

import qs

Item {
    id: root

    required property PanelWindow trunk
    required property Item triggerContent
    required property Item dropdownContent
    property Item boxParent: mouseArea
    property int padding: Config.borders.radius
    property int horizontalPadding: root.padding
    property int verticalPadding: root.padding
    property alias mouseArea: mouseArea
    property alias dropdown: dropdown

    onTriggerContentChanged: triggerContent.parent = mouseArea
    onDropdownContentChanged: {
        dropdownContent.parent = box;
        dropdownContent.anchors.centerIn = box;
    }

    implicitWidth: mouseArea.implicitWidth
    implicitHeight: mouseArea.implicitHeight

    Dropdown {
        id: dropdown
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

    // If the caller overrides the mouseArea hooks, such as onClicked, directly, their logic will be merged with ours.
    // If they override these functions instead, their logic will replace ours, which is sometimes desired.
    function mouseClick(event) {
        dropdown.toggle();
    }

    function mouseEnter() {
    }

    function mouseExit() {
        dropdown.close();
    }

    WrapperMouseArea {
        id: mouseArea
        hoverEnabled: true
        acceptedButtons: Qt.RightButton
        onClicked: event => mouseClick(event)
        onEntered: mouseEnter()
        onExited: mouseExit()
    }
}
