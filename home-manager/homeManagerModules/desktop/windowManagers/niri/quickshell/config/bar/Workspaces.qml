import QtQuick
import Quickshell.Widgets
import ".."
import "../.."

Row {
    required property var niri
    readonly property list<string> workspaceNames: ["", "󰈹", "", "󰯙", "󰔍", "󰓓", "󰎆", "", "󰇮", "󰍔"]

    anchors.verticalCenter: parent.verticalCenter

    WorkspaceIcon {
        text: ""
        textColor: Config.colors.base04
    }

    Repeater {
        model: niri.workspaces

        WrapperMouseArea {
            width: 22
            height: 24

            hoverEnabled: true
            onClicked: niri.focusWorkspaceById(model.id)
            cursorShape: Qt.PointingHandCursor

            WorkspaceIcon {
                text: workspaceNames[model.index - 1] ?? model.index
                textColor: model.isActive ? Config.colors.base0E : model.activeWindowId != "" ? Config.colors.base05 : Config.colors.base03
                bgColor: containsMouse ? Config.colors.base02 : Config.colors.base00
            }
        }
    }

    WorkspaceIcon {
        text: ""
        textColor: Config.colors.base04
    }
}
