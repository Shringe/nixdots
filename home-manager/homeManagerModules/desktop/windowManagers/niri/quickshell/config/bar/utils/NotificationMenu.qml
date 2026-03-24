import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls
import "../../.."
import "../.."
import "../utils"
import "../../Data" as Dat

Item {
    id: root
    width: 300
    height: mainLayout.implicitHeight
    required property PanelWindow trunk
    property int maxHeight: 520
    property bool previewMode: false
    signal closePreview

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
                text: previewMode ? "Dismiss" : "Clear all"
                onClicked: {
                    if (!previewMode)
                        Dat.Notifications.clearNotifs();
                    // open = false;
                    closePreview();
                }
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
            implicitHeight: Dat.Notifications.notifCount === 0 ? 60 : Math.min(notificationList.contentHeight + 24, root.maxHeight)

            // Empty state
            Column {
                anchors.centerIn: parent
                visible: Dat.Notifications.notifCount === 0
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
                visible: Dat.Notifications.notifCount > 0
                clip: true
                interactive: true
                spacing: 6

                verticalLayoutDirection: trunk.onBottom ? ListView.BottomToTop : ListView.TopToBottom
                ScrollBar.vertical: ScrollBar {}

                model: root.previewMode ? (Dat.Notifications.latestNotification ? [Dat.Notifications.latestNotification] : []) : Dat.Notifications.server.trackedNotifications
                delegate: NotificationBubble {
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
