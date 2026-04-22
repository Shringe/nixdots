import QtQuick

import "../../.."
import "../../Data" as Dat
import qs.inner.Shaders as Shaders

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
            layer.enabled: true
            layer.effect: Shaders.TwoColorAnimatedGradient {
                enabled: Dat.Mpris.isPlaying && Dat.Session.fancyAnimations
                angle: 180
                src: Config.colors.glsl.base09
                dst: Config.colors.glsl.base0A
            }
        }
    }
}
