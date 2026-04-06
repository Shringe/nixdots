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
    property int minimumDistanceFromScreenEdge: Config.borders.radius * 6
    property int gracePeriod: 500
    property bool wasLimited: false

    // the source of the menu
    required property var boxParent
    // the content of the dropdown
    default property alias content: contentArea.data
    property string debugName: "unknown"

    Component.onCompleted: {
        dropdown.parent = trunk.barItem;
    }

    // Request to open the dropdown
    function open() {
        if (trunk.output !== Dat.Session.currentScreen)
            return;
        root.show = true;
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
        let returnPos = {};
        returnPos.x = 0;
        returnPos.y = 0;
        if (node !== undefined && node !== null) {
            const parentValue = getAbsolutePosition(node.parent);
            returnPos.x = parentValue.x + node.x;
            returnPos.y = parentValue.y + node.y;
        }
        return returnPos;
    }

    function getScreenWidth() {
        return root.Window.window ? root.Window.window.width : 0;
    }

    Item {
        id: dropdown

        visible: false
        width: contentArea.implicitWidth
        height: contentArea.implicitHeight

        x: {
            const mapped = getAbsolutePosition(root.boxParent);
            const centered = mapped.x + (root.boxParent.width / 2) - (dropdown.width / 2) + xOffset;
            const screenWidth = getScreenWidth();
            const limited = Math.max(root.minimumDistanceFromScreenEdge, Math.min(centered, screenWidth - dropdown.width - root.minimumDistanceFromScreenEdge));
            root.wasLimited = centered !== limited;
            return limited;
        }

        y: {
            const mapped = getAbsolutePosition(root.boxParent);
            const out = trunk.onBottom ? mapped.y - getAbsolutePosition(root).y - dropdown.height + yOffset : mapped.y + root.boxParent.height + yOffset;
            // console.debug(`Dropdown ${debugName} y: ${out}`);
            return out;
        }

        opacity: 0
        scale: 0
        transformOrigin: trunk.onBottom ? Item.Bottom : Item.Top

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
                        target: trunk.dropdown
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

                    ScriptAction {
                        script: {
                            if (trunk.dropdown.owner === root) {
                                trunk.dropdown.x = 0;
                                trunk.dropdown.width = 0;
                                trunk.dropdown.height = 0;
                                trunk.dropdown.y = 0;
                                trunk.dropdown.owner = null;
                            }
                        }
                    }
                }
            }
        ]

        Shape {
            id: ramp
            preferredRendererType: Shape.CurveRenderer
            anchors.fill: parent

            transform: Scale {
                yScale: trunk.onBottom ? -1 : 1
                origin.y: ramp.height / 2
            }

            ShapePath {
                strokeColor: "transparent"
                strokeWidth: Config.borders.size > 0 ? Config.borders.size : -1
                fillColor: Config.colors.base00

                startX: -(Config.borders.radius * 2)
                startY: 0

                PathArc {
                    x: 0
                    y: Config.borders.radius * 2
                    radiusX: Config.borders.radius * 2
                    radiusY: Config.borders.radius * 2
                }

                PathLine {
                    x: 0
                    y: dropdown.height - Config.borders.radius
                }

                PathArc {
                    x: Config.borders.radius
                    y: dropdown.height
                    direction: PathArc.Counterclockwise
                    radiusX: Config.borders.radius
                    radiusY: Config.borders.radius
                }

                PathLine {
                    x: dropdown.width - Config.borders.radius
                    y: dropdown.height
                }

                PathArc {
                    x: dropdown.width
                    y: dropdown.height - Config.borders.radius
                    direction: PathArc.Counterclockwise
                    radiusX: Config.borders.radius
                    radiusY: Config.borders.radius
                }

                PathLine {
                    x: dropdown.width
                    y: Config.borders.radius * 2
                }

                PathArc {
                    x: dropdown.width + Config.borders.radius * 2
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

        onXChanged: {
            if (root.show && trunk.dropdown.owner === root) {
                trunk.dropdown.x = dropdown.x + (Config.borders.size * 2);
            }
        }

        onWidthChanged: {
            if (root.show && trunk.dropdown.owner === root) {
                trunk.dropdown.width = dropdown.width + (Config.borders.size * 2);
            }
        }

        onHeightChanged: {
            if (root.show && trunk.dropdown.owner === root) {
                trunk.dropdown.height = dropdown.height + (Config.borders.size * 2);
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
                trunk.dropdown.revealed = false;
            }
        }
    }

    onShowChanged: {
        if (show) {
            trunk.dropdown.owner = root;

            // Hack to align drodowns on my desktop for some reason
            if (trunk.laptop) {
                trunk.dropdown.x = dropdown.x + Config.borders.size * 2 + 1;
                trunk.dropdown.width = dropdown.width + Config.borders.size;
            } else if (root.wasLimited) {
                trunk.dropdown.x = dropdown.x + Config.borders.size * 2;
                trunk.dropdown.width = dropdown.width + Config.borders.size * 2;
            } else {
                trunk.dropdown.x = dropdown.x + Config.borders.size * 2;
                trunk.dropdown.width = dropdown.width + Config.borders.size * 2;
            }

            trunk.dropdown.y = dropdown.y;
            trunk.dropdown.height = dropdown.height + Config.borders.size;
        }
    }
}
