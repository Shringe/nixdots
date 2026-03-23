pragma ComponentBehavior: Bound

import Quickshell

import QtQuick
import QtQuick.Shapes

import qs

Item {
    id: root

    property alias timer: hideTimer
    property bool show: false
    // manual vertical offset
    property int offset: 0
    // the source of the menu
    required property var boxParent
    // the content of the dropdown
    default property alias content: contentArea.data

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

    Item {
        id: dropdown

        visible: false
        width: contentArea.implicitWidth
        height: contentArea.implicitHeight

        x: {
            const mapped = getAbsolutePosition(root.boxParent);
            const out = mapped.x + (root.boxParent.width / 2) - (dropdown.width / 2) - Config.borders.size * 2;
            return out;
        }

        y: {
            if (root.offset > 0) {
                return root.offset;
            }

            const mapped = getAbsolutePosition(root.boxParent);
            const out = mapped.y + root.boxParent.height + Config.borders.size + 1;
            return out;
        }

        opacity: 0
        scale: 0
        transformOrigin: Item.Top

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
                        target: States
                        property: "dropdownRevealed"
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
                            if (States.dropdownOwner === root) {
                                States.dropdownX = 0;
                                States.dropdownWidth = 0;
                                States.dropdownHeight = 0;
                                States.dropdownY = 0;
                                States.dropdownOwner = null;
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

            implicitWidth: children.length > 0 ? children[0].implicitWidth : 0
            implicitHeight: children.length > 0 ? children[0].implicitHeight : 0
        }

        HoverHandler {
            id: dropdownHover

            onHoveredChanged: {
                if (hovered) {
                    hideTimer.stop();
                } else {
                    hideTimer.start();
                }
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 120
        repeat: false

        onTriggered: {
            if (!dropdownHover.hovered) {
                root.show = false;
                States.dropdownRevealed = false;
            }

            if (States.dashboardPresent)
                States.dashboardPresent = false;
        }
    }

    onShowChanged: {
        if (show) {
            States.dropdownOwner = root;

            let barItem = root.parent;

            while (barItem && barItem.parent && barItem.parent.parent) {
                barItem = barItem.parent;
            }

            const mapped = root.boxParent.mapToItem(barItem, 0, 0);
            const centerX = mapped.x - (dropdown.width / 2) + (root.boxParent.width / 2);

            States.dropdownX = centerX;
            States.dropdownWidth = dropdown.width + (Config.borders.size * 2);
            States.dropdownHeight = dropdown.height + (Config.borders.size * 2);
            States.dropdownY = dropdown.y;
        }
    }
}
