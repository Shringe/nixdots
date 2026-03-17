import QtQuick
import "../../.."
import "../../Data" as Dat

Row {
    anchors.verticalCenter: parent.verticalCenter
    height: 20
    spacing: 2
    topPadding: 2
    bottomPadding: 2

    Repeater {
        model: Dat.Cava.bars.length

        Rectangle {
            width: 4
            height: Math.max(2, Dat.Cava.bars[index] / 50)
            anchors.bottom: parent.bottom
            color: Config.colors.base05
        }
    }
}
