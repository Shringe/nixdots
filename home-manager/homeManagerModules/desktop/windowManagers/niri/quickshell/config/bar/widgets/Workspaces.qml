import QtQuick
import Quickshell.Widgets
import ".."
import "../.."
import "../../.."
import "../utils"
import qs.inner.Data as Dat

Row {
    id: root
    readonly property list<string> indexToName: ["", "󰈹", "", "󰯙", "󰔍", "󰓓", "󰎆", "", "󰇮", "󰍔"]
    property string output

    function getDisplayName(workspace) {
        switch (workspace.name) {
        case "":
            return indexToName[workspace.index - 1] ?? workspace.index;
            break;
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
            visible: model.output === root.output
            implicitWidth: 22
            implicitHeight: 20

            hoverEnabled: true
            onClicked: Dat.Session.niri.focusWorkspaceById(model.id)
            cursorShape: Qt.PointingHandCursor

            Item {
                Loader {
                    active: model.name !== ""
                    visible: active
                    anchors.centerIn: parent
                    WorkspaceIcon {
                        text: getDisplayName(model)
                        bgColor: containsMouse ? Config.colors.base02 : Config.colors.base00
                        label.font.pixelSize: Config.fonts.size + 4
                        label.layer.enabled: true
                        label.layer.effect: ShaderEffect {
                            property real angle: 120
                            property real split: 0.45
                            property vector3d src: model.isActive ? Config.colors.glsl.base0E : model.activeWindowId != "" ? Config.colors.glsl.base05 : Config.colors.glsl.base03
                            property vector3d dst: model.isActive ? Config.colors.glsl.base06 : Config.colors.glsl.base04
                            property real time: Dat.Workspaces.animClock
                            fragmentShader: "../../shaders/bin/TwoColorAnimatedGradient.frag.qsb"
                        }
                    }
                }

                Loader {
                    active: model.name === ""
                    visible: active
                    anchors.centerIn: parent
                    WorkspaceIcon {
                        text: getDisplayName(model)
                        bgColor: containsMouse ? Config.colors.base02 : Config.colors.base00
                        label.font.pixelSize: Config.fonts.size
                        label.color: model.isActive ? Config.colors.base0E : model.activeWindowId != "" ? Config.colors.base05 : Config.colors.base03
                    }
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
