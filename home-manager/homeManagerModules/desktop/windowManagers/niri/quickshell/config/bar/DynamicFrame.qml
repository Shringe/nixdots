import Quickshell
import QtQuick
import QtQuick.Shapes
import qs

Shape {
    id: root

    required property PanelWindow trunk
    property int barWidth: trunk.bar.width
    property int barHeight: trunk.bar.height
    property bool onBottom: trunk.onBottom

    readonly property int sw: Config.borders.size
    readonly property int cr: Config.borders.radius
    readonly property int ramp: cr * 2

    preferredRendererType: Shape.CurveRenderer
    width: barWidth + sw
    height: barHeight + sw
    x: -sw / 2
    y: -sw / 2

    // Mirroring vertically on rot.onBottom
    transform: Scale {
        yScale: root.onBottom ? -1 : 1
        origin.y: root.height / 2
    }

    ShapePath {
        strokeColor: Config.colors.base02
        strokeWidth: root.sw
        fillColor: "transparent"

        // top-left corner start
        startX: root.cr
        startY: 0

        // top edge
        PathMove {
            x: bar.width - root.cr
            y: 0
        }

        // top-right corner
        PathMove {
            x: bar.width
            y: root.cr
        }

        // right edge down
        PathMove {
            x: bar.width
            y: bar.height - root.cr
        }

        // bottom-right corner
        PathArc {
            x: bar.width - root.cr
            y: bar.height
            radiusX: root.cr
            radiusY: root.cr
        }

        // bottom edge right side, up to dropdown right ramp
        PathLine {
            x: trunk.dropdown.revealed ? trunk.dropdown.x + trunk.dropdown.width + root.ramp - root.sw / 2 : root.cr
            y: bar.height
        }

        // dropdown gap
        PathMove {
            x: trunk.dropdown.revealed ? trunk.dropdown.x + trunk.dropdown.width + root.ramp - root.sw / 2 : root.cr
            y: bar.height
        }

        // ramp into dropdown right side (curves down and left)
        PathArc {
            x: trunk.dropdown.revealed ? trunk.dropdown.x + trunk.dropdown.width - root.sw / 2 : root.cr
            y: trunk.dropdown.revealed ? bar.height + root.ramp : bar.height
            radiusX: root.ramp
            radiusY: root.ramp
            direction: PathArc.Counterclockwise
        }

        // dropdown right edge down
        PathLine {
            x: trunk.dropdown.revealed ? trunk.dropdown.x + trunk.dropdown.width - root.sw / 2 : root.cr
            y: trunk.dropdown.revealed ? bar.height + trunk.dropdown.height - root.cr - root.sw / 2 : bar.height
        }

        // dropdown bottom-right corner
        PathArc {
            x: trunk.dropdown.revealed ? trunk.dropdown.x + trunk.dropdown.width - root.cr - root.sw / 2 : root.cr
            y: trunk.dropdown.revealed ? bar.height + trunk.dropdown.height - root.sw / 2 : bar.height
            radiusX: root.cr
            radiusY: root.cr
            direction: PathArc.Clockwise
        }

        // dropdown bottom edge
        PathLine {
            x: trunk.dropdown.revealed ? trunk.dropdown.x + root.cr + root.sw / 2 : root.cr
            y: trunk.dropdown.revealed ? bar.height + trunk.dropdown.height - root.sw / 2 : bar.height
        }

        // dropdown bottom-left corner
        PathArc {
            x: trunk.dropdown.revealed ? trunk.dropdown.x + root.sw / 2 : root.cr
            y: trunk.dropdown.revealed ? bar.height + trunk.dropdown.height - root.cr - root.sw / 2 : bar.height
            radiusX: root.cr
            radiusY: root.cr
            direction: PathArc.Clockwise
        }

        // dropdown left edge up
        PathLine {
            x: trunk.dropdown.revealed ? trunk.dropdown.x + root.sw / 2 : root.cr
            y: trunk.dropdown.revealed ? bar.height + root.ramp : bar.height
        }

        // ramp back to bar bottom (curves up and left)
        PathArc {
            x: trunk.dropdown.revealed ? trunk.dropdown.x - root.ramp + root.sw / 2 : root.cr
            y: bar.height
            radiusX: root.ramp
            radiusY: root.ramp
            direction: PathArc.Counterclockwise
        }

        // bottom edge left side
        PathLine {
            x: root.cr
            y: bar.height
        }

        // bottom-left corner
        PathArc {
            x: 0
            y: bar.height - root.cr
            radiusX: root.cr
            radiusY: root.cr
        }

        // left edge up
        PathMove {
            x: 0
            y: root.cr
        }

        // top-left corner close
        PathMove {
            x: root.cr
            y: 0
        }
    }
}
