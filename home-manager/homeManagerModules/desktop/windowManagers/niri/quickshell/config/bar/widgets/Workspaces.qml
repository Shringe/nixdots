import QtQuick
import Quickshell.Widgets
import ".."
import "../.."
import "../../.."
import "../utils"
import qs.inner.Data as Dat

Row {
    readonly property list<string> workspaceNames: ["", "󰈹", "", "󰯙", "󰔍", "󰓓", "󰎆", "", "󰇮", "󰍔"]

    WorkspaceIcon {
        text: ""
        textColor: Config.colors.base04
    }

    Repeater {
        model: Dat.Session.niri.workspaces

        WrapperMouseArea {
            width: icon.implicitWidth
            height: icon.impicitHeight

            hoverEnabled: true
            onClicked: Dat.Session.niri.focusWorkspaceById(model.id)
            cursorShape: Qt.PointingHandCursor

            WorkspaceIcon {
                id: icon
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
