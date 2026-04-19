import QtQuick
import ".."
import "../.."
import "../../.."

Rectangle {
    required property string text
    property string textColor: Config.colors.base03
    property color bgColor: Config.colors.base00
    property alias label: inner

    color: bgColor

    Stext {
        id: inner
        anchors.centerIn: parent
        text: parent.text
        color: parent.textColor
    }
}
