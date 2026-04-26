import QtQuick
import Quickshell.Widgets
import "../../.."
import "../.."

WrapperMouseArea {
    id: root

    property string text: ""
    property color color: Config.colors.base02
    property color pressedColor: Config.colors.base03
    property color currentColor: root.pressed ? root.pressedColor : root.color
    property int radius: 6
    property int horizontalPadding: 16
    property int verticalPadding: 8
    property alias label: label
    property alias rect: rect

    implicitWidth: label.implicitWidth + horizontalPadding
    implicitHeight: label.implicitHeight + verticalPadding

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    Rectangle {
        id: rect

        anchors.fill: parent
        color: currentColor
        radius: root.radius

        Stext {
            id: label
            anchors.centerIn: parent
            text: root.text
        }
    }
}
