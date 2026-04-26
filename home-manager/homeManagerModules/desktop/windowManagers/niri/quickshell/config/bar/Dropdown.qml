pragma ComponentBehavior: Bound

import Quickshell

import QtQuick
import QtQuick.Shapes

import qs
import qs.inner.Data as Dat

Item {
    id: root

    readonly property alias dropdownItem: dropdown
    required property PanelWindow trunk
    property alias timer: hideTimer
    property bool show: false
    property int xOffset: 0
    property int yOffset: 0
    // Whether to sit on the bottom of the screen
    property bool onBottom: trunk.onBottom
    // How close the dropdown can sit to either screen edge
    property int minimumDistanceFromScreenEdge: Config.borders.radius * 6
    // How long in ms the mouse can be outside of `region` before we close the dropdown
    property int gracePeriod: 500
    // Whetehr or not `minimumDistanceFromScreenEdge` mattered
    property bool wasLimited: false
    // Whether the dropdown is requesting to be shown by its parent. This is similar to `show`,
    // but `revealed` will also be active during the opening and closing animations.
    property bool revealed: false
    // The region that the dropdown wants to accept mouse events from
    property Region region: Region {
        item: dropdown
    }

    // the source of the menu
    required property var boxParent
    // the content of the dropdown
    default property alias content: contentArea.data
    property string debugName: "unknown"

    Component.onCompleted: {
        dropdown.parent = trunk.barItem;
        trunk.dropdowns = trunk.dropdowns.concat(this);
    }
    Component.onDestruction: trunk.dropdowns = trunk.dropdowns.filter(d => d !== this)

    // Request to open the dropdown
    function open() {
        if (trunk.output !== Dat.Session.currentScreen)
            return;
        root.show = true;
    }

    // Toggle the dropdown open or closed
    function toggle(closeDuration) {
        if (root.show) {
            close(closeDuration ?? 0);
        } else {
            open();
        }
    }

    // Prop the dropdown open for a specified time, then close
    function propOpen(duration) {
        if (!root.timer.running) {
            open();
        }
        close(duration);
    }

    // Request to close the dropdown
    function close(duration) {
        root.timer.interval = duration ?? root.gracePeriod;
        root.timer.restart();
    }

    function getAbsolutePosition(node) {
        let x = 0;
        let y = 0;
        while (node !== undefined && node !== null) {
            x += node.x;
            y += node.y;
            node = node.parent;
        }
        return {
            x,
            y
        };
    }

    function getScreenWidth() {
        return root.Window.window ? root.Window.window.width : 0;
    }

    Item {
        id: dropdown

        visible: false
        width: contentArea.implicitWidth
        height: contentArea.implicitHeight

        readonly property var mapped: getAbsolutePosition(root.boxParent)

        x: {
            const centered = mapped.x + (root.boxParent.width / 2) - (dropdown.width / 2) + xOffset;
            const screenWidth = getScreenWidth();
            const limited = Math.max(root.minimumDistanceFromScreenEdge, Math.min(centered, screenWidth - dropdown.width - root.minimumDistanceFromScreenEdge));
            root.wasLimited = centered !== limited;
            return limited;
        }

        y: {
            const hangFromBar = root.onBottom === trunk.onBottom;
            const openUpwards = root.onBottom;
            if (openUpwards && hangFromBar) {
                return mapped.y - getAbsolutePosition(root).y - dropdown.height + yOffset;
            } else if (openUpwards) {
                return mapped.y - getAbsolutePosition(root).y - dropdown.height + trunk.height;
            } else if (hangFromBar) {
                return mapped.y + root.boxParent.height + Config.borders.size + 1 + yOffset;
            } else {
                return root.boxParent.height + Config.borders.size + 1 - trunk.height;
            }
        }

        opacity: 0
        scale: 0
        transformOrigin: root.onBottom ? Item.Bottom : Item.Top

        states: [
            State {
                name: "visible"
                when: root.show

                PropertyChanges {
                    target: dropdown
                    opacity: 1
                    scale: 1
                }
            },
            State {
                name: "hidden"
                when: !root.show

                PropertyChanges {
                    target: dropdown
                    opacity: 0
                    scale: 0.65
                }
            }
        ]

        transitions: [
            Transition {
                from: "hidden"
                to: "visible"
                SequentialAnimation {
                    PropertyAction {
                        target: dropdown
                        property: "visible"
                        value: true
                    }

                    ParallelAnimation {
                        NumberAnimation {
                            property: "opacity"
                            duration: 250 / 2
                            easing.type: Easing.OutCubic
                        }

                        NumberAnimation {
                            property: "scale"
                            duration: 250 / 2
                            easing.type: Easing.OutCubic
                        }
                    }

                    PropertyAction {
                        target: root
                        property: "revealed"
                        value: true
                    }
                }
            },
            Transition {
                from: "visible"
                to: "hidden"

                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation {
                            property: "opacity"
                            duration: 250 / 2
                            easing.type: Easing.InCubic
                        }

                        NumberAnimation {
                            property: "scale"
                            duration: 250 / 2
                            easing.type: Easing.InCubic
                        }
                    }

                    PropertyAction {
                        target: dropdown
                        property: "visible"
                        value: false
                    }
                }
            }
        ]

        // Covers the seam between the bar and dropdown
        Rectangle {
            x: -(Config.borders.radius * 2)
            y: root.onBottom ? dropdown.height : -2
            width: dropdown.width + 1 + Config.borders.radius * 4
            height: 2
            color: Config.colors.base00
        }

        Shape {
            id: ramp
            preferredRendererType: Shape.CurveRenderer
            anchors.fill: parent

            transform: Scale {
                yScale: root.onBottom ? -1 : 1
                origin.y: ramp.height / 2
            }

            ShapePath {
                strokeColor: Config.colors.base03
                strokeWidth: Config.borders.size
                fillColor: Config.colors.base00

                startX: -(Config.borders.radius * 2)
                startY: 0

                PathArc {
                    x: -1
                    y: Config.borders.radius * 2
                    radiusX: Config.borders.radius * 2
                    radiusY: Config.borders.radius * 2
                }

                PathLine {
                    x: -1
                    y: dropdown.height - Config.borders.radius
                }

                PathArc {
                    x: Config.borders.radius
                    y: dropdown.height + 1
                    direction: PathArc.Counterclockwise
                    radiusX: Config.borders.radius
                    radiusY: Config.borders.radius
                }

                PathLine {
                    x: dropdown.width - Config.borders.radius
                    y: dropdown.height + 1
                }

                PathArc {
                    x: dropdown.width + 1
                    y: dropdown.height + 1 - Config.borders.radius
                    direction: PathArc.Counterclockwise
                    radiusX: Config.borders.radius
                    radiusY: Config.borders.radius
                }

                PathLine {
                    x: dropdown.width + 1
                    y: Config.borders.radius * 2
                }

                PathArc {
                    x: dropdown.width + 1 + Config.borders.radius * 2
                    y: 0
                    radiusX: Config.borders.radius * 2
                    radiusY: Config.borders.radius * 2
                }
            }
        }

        Item {
            id: contentArea
            z: 0

            implicitWidth: children.length > 0 ? children[0].width ?? children[0].implicitWidth : 0
            implicitHeight: children.length > 0 ? children[0].height ?? children[0].implicitHeight : 0
        }

        HoverHandler {
            id: dropdownHover

            onHoveredChanged: {
                if (hovered) {
                    if (hideTimer.interval > root.gracePeriod)
                        hideTimer.interval = root.gracePeriod;
                    hideTimer.stop();
                } else {
                    hideTimer.start();
                }
            }
        }
    }

    Timer {
        id: hideTimer
        interval: root.gracePeriod
        repeat: false

        onTriggered: {
            if (!dropdownHover.hovered) {
                root.show = false;
                revealed = false;
            }
        }
    }
}
