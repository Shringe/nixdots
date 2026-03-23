import QtQuick
import ".."
import "../.."
import "../../.."

Rectangle {
    required property string text
    property string textColor: Config.colors.base03
    property color bgColor: Config.colors.base00

    implicitWidth: 22
    implicitHeight: 20
    color: bgColor

    Stext {
        anchors.centerIn: parent
        text: parent.text
        color: parent.textColor
    }
}
