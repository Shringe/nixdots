// Shares some common state to reduce the overhead of workspace icon shaders
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // This is done to reduce repaints the shader causes
    property real animClock: _animClock > 1.0 ? 1.0 : _animClock
    property real _animClock: 0.0
    NumberAnimation on _animClock {
        from: -1.0
        to: 2.0
        duration: 5000
        loops: Animation.Infinite
        running: true
    }
}
