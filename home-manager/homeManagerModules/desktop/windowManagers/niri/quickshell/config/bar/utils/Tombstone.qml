import QtQuick
import QtQuick.Shapes
import "../../.."

Item {
    id: root

    default property alias content: inner.data

    readonly property real flare: 16
    readonly property real curveStart: flare * 0.5  // 0.0 = sharp, flare = full quarter-ellipse
    readonly property real r: 8
    property color backgroundColor: Config.colors.base00

    implicitWidth: inner.implicitWidth + flare * 2
    implicitHeight: inner.implicitHeight

    Shape {
        anchors.fill: parent

        ShapePath {
            fillColor: backgroundColor
            strokeWidth: -1

            startX: root.flare + root.r
            startY: height

            // bottom edge →
            PathLine {
                x: width - root.flare - root.r
                y: height
            }

            // bottom-right corner ↱
            PathArc {
                x: width - root.flare
                y: height - root.r
                radiusX: root.r
                radiusY: root.r
                direction: PathArc.Counterclockwise
            }

            // right side ↑
            PathLine {
                x: width - root.flare
                y: root.curveStart
            }

            // top-right flare: sweeps outward to full width
            PathArc {
                x: width
                y: 0
                radiusX: root.flare
                radiusY: root.curveStart
            }

            // top edge ←
            PathLine {
                x: 0
                y: 0
            }

            // top-left flare: sweeps inward back to content edge
            PathArc {
                x: root.flare
                y: root.curveStart
                radiusX: root.flare
                radiusY: root.curveStart
            }

            // left side ↓
            PathLine {
                x: root.flare
                y: height - root.r
            }

            // bottom-left corner ↲
            PathArc {
                x: root.flare + root.r
                y: height
                radiusX: root.r
                radiusY: root.r
                direction: PathArc.Counterclockwise
            }
        }
    }

    Item {
        id: inner
        x: root.flare
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
