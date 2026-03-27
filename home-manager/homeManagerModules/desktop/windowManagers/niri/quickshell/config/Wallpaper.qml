import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    property string name: "DarkNord_3440x1440.png"
    readonly property string wallpaperDir: "/nixdots/assets/wallpapers/"

    // Used only to remove warnings in quickshell logs
    required property ShellScreen output
    screen: output

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Background

    Image {
        anchors.fill: parent
        source: wallpaperDir + name
        cache: false
        smooth: false
        autoTransform: false
    }
}
