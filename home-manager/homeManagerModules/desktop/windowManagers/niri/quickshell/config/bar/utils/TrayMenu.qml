pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import ".."
import "../.."
import "../../.."

StackView {
    id: root

    required property var menu

    implicitWidth: currentItem?.implicitWidth ?? 0
    implicitHeight: currentItem?.implicitHeight ?? 0
    width: 200

    pushEnter: null
    pushExit: null
    popEnter: null
    popExit: null

    onVisibleChanged: {
        if (!visible)
            root.pop(null);
    }

    initialItem: SubMenu {
        handle: root.menu
    }

    component SubMenu: Column {
        id: menu

        required property QsMenuHandle handle
        property bool isSubMenu: false

        padding: 4
        spacing: 2

        QsMenuOpener {
            id: opener
            menu: menu.handle
        }

        Repeater {
            model: opener.children

            delegate: Rectangle {
                required property QsMenuEntry modelData

                width: root.width
                height: modelData.isSeparator ? 1 : 28
                color: modelData.isSeparator ? Config.colors.base02 : mouseArea.containsMouse && modelData.enabled ? Config.colors.base02 : Config.colors.base00

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: modelData.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: {
                        if (!modelData.enabled)
                            return;
                        if (modelData.hasChildren)
                            root.push(subMenuComp, {
                                handle: modelData,
                                isSubMenu: true
                            });
                        else
                            modelData.triggered();
                    }
                }

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    spacing: 6
                    visible: !modelData.isSeparator

                    IconImage {
                        width: 16
                        height: 16
                        anchors.verticalCenter: parent.verticalCenter
                        source: modelData.icon
                        visible: modelData.icon !== ""
                    }

                    Stext {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.text
                        color: modelData.enabled ? Config.colors.base05 : Config.colors.base03
                    }

                    Stext {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "›"
                        color: Config.colors.base03
                        visible: modelData.hasChildren
                    }
                }
            }
        }

        // Back button for submenus
        WrapperMouseArea {
            visible: menu.isSubMenu
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.pop()
            width: root.width
            height: 28

            Rectangle {
                width: root.width
                height: 28
                color: parent.containsMouse ? Config.colors.base02 : Config.colors.base00

                Stext {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    text: "‹ Back"
                    color: Config.colors.base0E
                }
            }
        }
    }

    Component {
        id: subMenuComp
        SubMenu {}
    }
}
