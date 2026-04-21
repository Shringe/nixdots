import QtQuick
import Quickshell.Widgets
import ".."
import "../.."
import "../../.."
import "../utils"
import qs.inner.Data as Dat
import qs.inner.Shaders as Shaders

Row {
    id: root
    readonly property list<string> indexToName: ["", "󰈹", "", "󰯙", "󰔍", "󰓓", "󰎆", "", "󰇮", "󰍔"]
    property string output

    function getDisplayName(workspace) {
        switch (workspace.name) {
        case "":
            return indexToName[workspace.index - 1] ?? workspace.index;
            break;
        case "chat":
            return "C";
        default:
            return workspace.name[0].toUpperCase();
        }
    }

    WorkspaceIcon {
        text: ""
        textColor: Config.colors.base04
        implicitWidth: 22
        implicitHeight: 20
    }

    Repeater {
        model: Dat.Session.niri.workspaces

        WrapperMouseArea {
            readonly property bool isNamed: model.name !== ""
            readonly property bool isActive: model.isActive
            readonly property bool hasWindow: model.activeWindowId != ""
            readonly property bool isCurrentScreen: model.output === Dat.Session.currentScreen.name

            visible: model.output === root.output
            implicitWidth: 22
            implicitHeight: 20

            hoverEnabled: true
            onClicked: Dat.Session.niri.focusWorkspaceById(model.id)
            cursorShape: Qt.PointingHandCursor

            WorkspaceIcon {
                text: getDisplayName(model)
                bgColor: containsMouse ? Config.colors.base02 : Config.colors.base00
                label.font.pixelSize: isNamed ? Config.fonts.size + 4 : Config.fonts.size
                label.color: isActive ? Config.colors.base0E : hasWindow ? Config.colors.base05 : Config.colors.base03
                label.layer.enabled: isNamed || (isActive && isCurrentScreen)
                label.layer.effect: Shaders.TwoColorAnimatedGradient {
                    src: isActive ? Config.colors.glsl.base0E : hasWindow ? Config.colors.glsl.base05 : Config.colors.glsl.base03
                    dst: isActive ? Config.colors.glsl.base06 : Config.colors.glsl.base04
                }
            }
        }
    }

    WorkspaceIcon {
        text: ""
        textColor: Config.colors.base04
        implicitWidth: 22
        implicitHeight: 20
    }
}
