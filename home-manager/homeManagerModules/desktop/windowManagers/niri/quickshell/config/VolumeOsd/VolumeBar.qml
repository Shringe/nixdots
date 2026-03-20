import QtQuick
import "../.."

Rectangle {
    id: root

    property real volume: 0
    property bool muted: false

    implicitHeight: 10
    color: root.muted ? Config.colors.base02 : Config.colors.base04

    Rectangle {
        anchors.left: root.left
        radius: root.radius
        implicitHeight: root.implicitHeight
        implicitWidth: root.width * root.volume
        color: root.muted ? Config.colors.base03 : Config.colors.base05
    }
}
