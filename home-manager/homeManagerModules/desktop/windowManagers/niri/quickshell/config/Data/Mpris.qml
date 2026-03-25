pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    readonly property MprisPlayer player: Mpris.players.values[0] ?? null
    readonly property string trackTitle: player?.trackTitle ?? ""
    readonly property bool trackHasTitle: trackTitle !== ""
    readonly property string artist: player?.trackArtist ?? ""
    readonly property bool isPlaying: player?.playbackState === MprisPlaybackState.Playing
    readonly property string icon: isPlaying ? "󰐊" : "󰏤"
    readonly property real volume: player?.volume
    property bool skipNextVolumeUpdate: false

    signal volumeUpdate
    signal playPauseUpdate
    signal trackUpdate

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

        const base_increment = 0.01;
        const increment = event.angleDelta.y < 0 ? -base_increment : base_increment;
        const incremented = _cleanVolume(player.volume + increment);
        if (player.volume === incremented) {
            volumeUpdate();
        } else {
            player.volume = incremented;
        }
    }

    function _cleanVolume(volume) {
        return _limitVolume(_roundVolume(volume));
    }

    function _limitVolume(volume) {
        return Math.max(0.0, Math.min(1.0, volume));
    }

    function _roundVolume(volume) {
        return Math.round(volume * 100) / 100;
    }

    Connections {
        target: player
        function onVolumeChanged() {
            if (skipNextVolumeUpdate) {
                skipNextVolumeUpdate = false;
                return;
            }
            const dirty = player.volume;
            const clean = _cleanVolume(dirty);
            if (clean !== dirty) {
                player.volume = clean;
                skipNextVolumeUpdate = true;
            }
            volumeUpdate();
        }
        function onIsPlayingChanged() {
            playPauseUpdate();
        }
        function onTrackTitleChanged() {
            trackUpdate();
        }
    }
}
