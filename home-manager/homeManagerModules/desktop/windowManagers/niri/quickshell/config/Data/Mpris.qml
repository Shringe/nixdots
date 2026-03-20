pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    readonly property MprisPlayer player: Mpris.players.values[0] ?? null
    readonly property string trackTitle: player?.trackTitle ?? ""
    readonly property bool trackHasTitle: trackTitle !== ""
    readonly property string artist: player?.identity ?? ""
    readonly property bool isPlaying: player?.playbackState === MprisPlaybackState.Playing
    readonly property string icon: isPlaying ? "󰐊" : "󰏤"
    readonly property real volume: player?.volume

    function playPause() {
        player?.togglePlaying();
    }

    function next() {
        player?.next();
    }

    function prev() {
        player?.previous();
    }

    function stop() {
        player?.stop();
    }

    function wheelAction(event: WheelEvent) {
        if (player === null)
            return;
        if (event.angleDelta.y < 0) {
            player.volume = Math.max(0, player.volume - 0.01);
        } else {
            player.volume = Math.min(1, player.volume + 0.01);
        }
    }
}
