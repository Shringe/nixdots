import QtQuick
import ".."
import "../.."

Rectangle {
    required property string text
    property string textColor: Config.colors.base03
    property color bgColor: Config.colors.base00

    width: 22
    height: 24
    color: bgColor

    Stext {
        anchors.centerIn: parent
        text: parent.text
        color: parent.textColor
    }
}
