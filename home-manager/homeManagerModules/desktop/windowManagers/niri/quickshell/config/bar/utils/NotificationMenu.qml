import QtQuick
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
    property int maxHeight: 520

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        spacing: 6

        // Header row
        RowLayout {
            Layout.fillWidth: true

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
                text: "Clear all"
                onClicked: Dat.Notifications.clearNotifs()
            }

            Spacer {
                width: 5
            }
        }

        // Body
        Rectangle {
            Layout.fillWidth: true
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

                // verticalLayoutDirection: ListView.BottomToTop
                ScrollBar.vertical: ScrollBar {}

                model: Dat.Notifications.server.trackedNotifications
                delegate: Rectangle {
                    required property var modelData
                    width: ListView.view.width
                    height: notifContent.implicitHeight + 16
                    radius: 6
                    color: Config.colors.base00

                    RowLayout {
                        id: notifContent
                        anchors {
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            margins: 10
                        }
                        spacing: 8

                        Column {
                            Layout.fillWidth: true
                            spacing: 2

                            Stext {
                                width: parent.width
                                text: modelData.appName
                                elide: Text.ElideRight
                                color: Config.colors.base09
                            }

                            Stext {
                                width: parent.width
                                text: modelData.summary
                                elide: Text.ElideRight
                                color: modelData.body === "" ? Config.colors.base05 : Config.colors.base0F
                            }

                            Stext {
                                width: parent.width
                                text: modelData.body
                                wrapMode: Text.WordWrap
                                visible: modelData.body !== ""
                            }
                        }

                        // Per notification dismiss
                        TextButton {
                            text: "X"
                            onClicked: modelData.dismiss()
                        }
                    }
                }
            }
        }
    }
}
