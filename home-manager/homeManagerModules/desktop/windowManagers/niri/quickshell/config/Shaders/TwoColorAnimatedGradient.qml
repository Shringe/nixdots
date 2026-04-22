import QtQuick
import Quickshell

import qs
import qs.inner.Data as Dat

ShaderEffect {
    // Use this instead of `layer.enabled` if you want fade in/out effects
    property bool enabled: true
    property real angle: 120
    property real split: 0.45
    property real time: Dat.Session.animClock
    property real progress: 0.0
    property vector3d base: Config.colors.glsl.base05
    property vector3d src: Config.colors.glsl.base05
    property vector3d dst: Config.colors.glsl.base04
    fragmentShader: Quickshell.shellDir + "/inner/Shaders/bin/TwoColorAnimatedGradient.frag.qsb"

    onEnabledChanged: {
        progressAnim.from = progress;
        progressAnim.to = enabled ? 1.0 : 0.0;
        progressAnim.restart();
    }

    NumberAnimation on progress {
        id: progressAnim
        from: 0.0
        to: 1.0
        duration: 600
        easing.type: Easing.OutCubic
    }
}
