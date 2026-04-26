import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls

import "../../.."
import "../.."
import "../utils"
import "../../Data" as Dat

import qs.inner.Shaders as Shaders

Item {
    id: root
    width: 350
    height: mainLayout.implicitHeight
    required property PanelWindow trunk
    property int maxHeight: 520
    property bool previewMode: false
    property bool historyMode: false
    signal closePreview

    property var notifications: root.previewMode ? (Dat.Notifications.latestNotification ? [Dat.Notifications.latestNotification] : []) : root.historyMode ? Dat.Notifications.history : Dat.Notifications.server.trackedNotifications

    property Component dndShader: Shaders.TwoColorAnimatedGradient {
        enabled: Dat.Notifications.dndEnabled
        src: Config.colors.glsl.base0E
        dst: Config.colors.glsl.base07
        fadeDuration: 300
    }

    GridLayout {
        id: mainLayout
        anchors.fill: parent
        rowSpacing: 6
        columns: 1

        // Header row
        RowLayout {
            Layout.fillWidth: true
            Layout.row: trunk.onBottom ? 1 : 0

            Spacer {
                width: 5
            }

            Stext {
                text: "Notifications"
                font.pixelSize: 16
                Layout.fillWidth: true
            }

            TextButton {
                visible: Dat.Notifications.notifCount > 0
                text: previewMode ? "Dismiss" : "Clear"
                onClicked: {
                    if (!previewMode)
                        Dat.Notifications.clearNotifs();
                    // open = false;
                    closePreview();
                }
            }

            TextButton {
                text: "History"
                onClicked: historyMode = !historyMode
                label.layer.enabled: true
                label.layer.effect: Shaders.TwoColorAnimatedGradient {
                    enabled: historyMode
                    src: Config.colors.glsl.base0E
                    dst: Config.colors.glsl.base07
                    fadeDuration: 300
                }
            }

            TextButton {
                text: "DND"
                onClicked: Dat.Notifications.dndEnabled = !Dat.Notifications.dndEnabled
                label.layer.enabled: true
                label.layer.effect: dndShader
            }

            Spacer {
                width: 5
            }
        }

        // Body
        Rectangle {
            Layout.fillWidth: true
            Layout.row: trunk.onBottom ? 0 : 1
            radius: 6
            color: Config.colors.base01
            implicitHeight: !root.historyMode && Dat.Notifications.notifCount === 0 ? 60 : Math.min(notificationList.contentHeight + 24, root.maxHeight)

            // Empty state
            Column {
                anchors.centerIn: parent
                visible: !historyMode && Dat.Notifications.notifCount === 0
                spacing: 6

                Stext {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "All clear!"
                }
            }

            ListView {
                id: notificationList
                anchors.fill: parent
                anchors.margins: 12
                visible: Dat.Notifications.notifCount > 0 || root.historyMode
                clip: true
                interactive: true
                spacing: 6

                verticalLayoutDirection: trunk.onBottom ? ListView.BottomToTop : ListView.TopToBottom
                ScrollBar.vertical: ScrollBar {}

                model: notifications
                delegate: NotificationBubble {
                    previewMode: root.historyMode
                    onDismissed: {
                        modelData.dismiss();
                        if (previewMode) {
                            // open = false;
                            previewMode = false;
                        }
                    }
                }
            }
        }
    }
}
