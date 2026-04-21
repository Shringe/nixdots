import QtQuick
import Quickshell

import qs
import qs.inner.Data as Dat

ShaderEffect {
    property real angle: 120
    property real split: 0.45
    property real time: Dat.Session.animClock
    property vector3d src: Config.colors.glsl.base05
    property vector3d dst: Config.colors.glsl.base04
    fragmentShader: Quickshell.shellDir + "/inner/Shaders/bin/TwoColorAnimatedGradient.frag.qsb"
}
