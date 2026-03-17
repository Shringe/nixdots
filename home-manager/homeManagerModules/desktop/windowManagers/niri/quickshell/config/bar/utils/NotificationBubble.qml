import QtQuick
import QtQuick.Layouts
import "../../.."
import "../.."

Rectangle {
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

        TextButton {
            text: "X"
            onClicked: modelData.dismiss()
        }
    }
}
