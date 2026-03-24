import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Niri
import "../.."
import "../Data" as Dat
import "utils"
import "separators"
import "widgets"
import ".."

PanelWindow {
    id: root
    WlrLayershell.layer: WlrLayer.Top

    required property var modelData
    readonly property Rectangle bar: bar
    readonly property ShellScreen output: modelData
    property bool laptop: false
    property bool onBottom: true
    property QtObject dropdown: QtObject {
        property bool revealed: false
        property var owner: null
        property int x: 0
        property int y: 0
        property int height: 0
        property int width: 0
    }

    screen: output
    anchors {
        top: !onBottom
        bottom: onBottom
        left: true
        right: true
    }

    mask: itemsRegions
    color: "transparent"
    implicitHeight: screen.height
    // this reserves the space for the bar
    exclusiveZone: bar.visible ? bar.height : 0

    // regions for all window components
    Region {
        id: itemsRegions
        regions: regions.instances
    }

    // iterates over all window components and
    // creates their regions
    Variants {
        id: regions
        model: root.dropdown.revealed ? getAllVisibleItems() : root.contentItem.children

        delegate: Region {
            required property Item modelData
            item: modelData
        }
    }

    Connections {
        target: root.dropdown

        function onRevealedChanged() {
            regions.model = root.dropdown.revealed ? getAllVisibleItems() : root.contentItem.children;
            itemsRegions.changed();
        }
    }

    function getAllVisibleItems() {
        const items = [];

        function collect(item) {
            if (!item)
                return;

            items.push(item);

            for (const child of item.children) {
                if (child.visible) {
                    collect(child);
                }
            }
        }

        collect(root.contentItem);
        return items;
    }

    Rectangle {
        id: bar
        y: root.onBottom ? root.screen.height - bar.height : 0
        implicitWidth: root.screen.width
        implicitHeight: 24
        color: Config.colors.base00

        bottomLeftRadius: root.onBottom ? 0 : Config.borders.radius
        bottomRightRadius: root.onBottom ? 0 : Config.borders.radius
        topLeftRadius: root.onBottom ? Config.borders.radius : 0
        topRightRadius: root.onBottom ? Config.borders.radius : 0

        DynamicFrame {
            trunk: root
        }

        Item {
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5

            Dropdown {
                id: clockDown
                trunk: root
                boxParent: clock
                debugName: "Clockdown"

                Rectangle {
                    color: Config.colors.base00
                    width: menu.width
                    height: menu.height
                    NotificationMenu {
                        id: menu
                        trunk: root
                    }
                }
            }

            // Left
            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                spacing: 5
                SystemTray {}
                LeftSeparator {}
                WindowTitle {}
                LeftSeparator {}
            }

            // Center
            Workspaces {
                anchors.centerIn: parent
            }

            // Right
            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                spacing: 5

                RightSeparator {}
                TextButton {
                    text: "Night"
                    verticalPadding: 1
                    onClicked: Dat.NightLight.toggle()
                }
                RightSeparator {}
                Audio {}
                RightSeparator {}
                HardwareMonitor {
                    laptop: laptop
                }
                RightSeparator {}
                Clock {
                    id: clock
                    dropdown: clockDown
                    trunk: root
                }
            }
        }
    }
}
