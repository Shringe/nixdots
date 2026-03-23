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
    property bool laptop: false

    screen: modelData
    anchors {
        top: true
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
        model: States.dropdownRevealed ? getAllVisibleItems() : root.contentItem.children

        delegate: Region {
            required property Item modelData
            item: modelData
        }
    }

    Connections {
        target: States

        function onDropdownRevealedChanged() {
            regions.model = States.dropdownRevealed ? getAllVisibleItems() : root.contentItem.children;
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
        y: 0
        implicitWidth: root.screen.width
        implicitHeight: 24 + Config.borders.size
        color: Config.colors.base00
        radius: 0

        DynamicFrame {
            barWidth: bar.width
            barHeight: bar.height
        }

        Niri {
            id: niri
            Component.onCompleted: connect()

            onConnected: console.debug("Connected to niri")
            onErrorOccurred: function (error) {
                console.error("Niri error:", error);
            }
        }

        Item {
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.bottomMargin: Config.borders.size

            Dropdown {
                id: dropdown
                boxParent: mouseArea
                debugName: "Demo"

                Rectangle {
                    color: "red"
                    implicitWidth: 180
                    implicitHeight: 80
                    radius: 8

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 4

                        Stext {
                            text: "Content Area"
                        }
                    }
                }
            }

            Dropdown {
                id: clockDown
                boxParent: clock
                debugName: "Clockdown"

                Rectangle {
                    color: "red"
                    implicitWidth: 180
                    implicitHeight: 80
                    radius: 8

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 4

                        Stext {
                            text: "Content Area"
                        }
                    }
                }
            }

            // Left
            Row {
                anchors.left: parent.left
                spacing: 5
                SystemTray {}
                LeftSeparator {}
                WindowTitle {
                    niri: niri
                }
                LeftSeparator {}
            }

            // Center
            Workspaces {
                anchors.centerIn: parent
                niri: niri
            }

            // Right
            Row {
                anchors.right: parent.right
                spacing: 5

                Rectangle {
                    color: Config.colors.base02
                    radius: Config.borders.radius
                    implicitWidth: 100
                    implicitHeight: 24
                    Stext {
                        anchors.centerIn: parent
                        text: "Hover Area"
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            dropdown.show = true;
                            States.dashboardPresent = true;
                        }

                        onExited: {
                            dropdown.timer.start();
                        }
                    }
                }

                RightSeparator {}
                TextButton {
                    text: "Night"
                    verticalPadding: 0
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
                }
            }
        }
    }
}
