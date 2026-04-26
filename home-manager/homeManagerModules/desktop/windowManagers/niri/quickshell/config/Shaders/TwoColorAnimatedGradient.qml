import QtQuick
import Quickshell

import qs
import qs.inner.Data as Dat

ShaderEffect {
    // Use this instead of `layer.enabled` if you want fading animations
    property bool enabled: true
    // The angle that `dst` will travel at
    property real angle: 120
    // The percentage of the gradient to be `dst` relative to `base`
    property real split: 0.45
    // The seed used to determine the frame in time to animate
    property real time: Dat.Session.animClock
    // How far along the fading animation is
    property real progress: 0.0
    // The base color. Blended with the gradient to achieve the fading animation
    property vector3d base: Config.colors.glsl.base05
    // The primary color of the gradient
    property vector3d src: Config.colors.glsl.base05
    // The secondary color of the gradient
    property vector3d dst: Config.colors.glsl.base04
    // The amount of time in ms to play the fade animation
    property int fadeDuration: 600

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
        duration: fadeDuration
        easing.type: Easing.OutCubic
    }
}
