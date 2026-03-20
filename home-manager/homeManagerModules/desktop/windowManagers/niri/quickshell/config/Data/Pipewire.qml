// https://github.com/krishna4a6av/kurukuruBar/blob/master/Data/Audio.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool sinkMuted: sink?.audio.muted
    readonly property real sinkVolume: sink?.audio.volume
    readonly property string sinkIcon: {
        (sinkMuted) ? "󰝟" : (sinkVolume > 0.5) ? "󰕾" : (sinkVolume > 0.01) ? "󰖀" : "󰕿";
    }

    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property bool sourceMuted: source?.audio.muted
    readonly property real sourceVolume: source?.audio.volume
    readonly property string sourceIcon: (sourceMuted) ? "󰍭" : "󰍬"

    signal volumeUpdate(isSource: bool)

    function toggleMute(node: PwNode) {
        node.audio.muted = !node.audio.muted;
    }

    function wheelAction(event: WheelEvent, node: PwNode) {
        if (event.angleDelta.y < 0) {
            node.audio.volume -= 0.01;
        } else {
            node.audio.volume += 0.01;
        }

        if (node.audio.volume > 1.3) {
            node.audio.volume = 1.3;
        }
        if (sink.audio.volume < 0) {
            node.audio.volume = 0.0;
        }
    }

    PwObjectTracker {
        objects: [sink, source]
    }

    Connections {
        target: sink.audio
        function onVolumeChanged() {
            volumeUpdate(false);
        }
        function onMutedChanged() {
            volumeUpdate(false);
        }
    }

    Connections {
        target: source.audio
        function onVolumeChanged() {
            volumeUpdate(true);
        }
        function onMutedChanged() {
            volumeUpdate(true);
        }
    }
}
