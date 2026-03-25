import QtQuick
import qs

Rectangle {
    id: root

    property real volume: 0
    property bool muted: false

    implicitHeight: 10
    color: root.muted ? Config.colors.base02 : Config.colors.base04

    // Creates a small colored section at the end to indicate that the volume is not fully up
    Rectangle {
        id: lastArea
        anchors.right: root.right
        radius: root.radius
        implicitHeight: root.implicitHeight
        implicitWidth: Math.max(root.implicitHeight * 2, Math.min(root.implicitHeight * 3, root.implicitWidth * 0.1))
        color: Config.colors.base0E
    }

    // Rounds the inside of lastArea concavely
    Rectangle {
        x: root.implicitWidth - lastArea.implicitWidth - root.radius * 2
        radius: root.radius
        implicitHeight: root.implicitHeight
        implicitWidth: root.implicitHeight * 2
        color: root.color
    }

    // Active volume
    Rectangle {
        anchors.left: root.left
        radius: root.radius
        implicitHeight: root.implicitHeight
        implicitWidth: root.width * Math.min(1.0, root.volume)
        color: root.muted ? Config.colors.base03 : Config.colors.base05
    }
}
