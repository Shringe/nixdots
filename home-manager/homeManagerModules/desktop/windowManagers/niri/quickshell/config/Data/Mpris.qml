pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

// TODO: implement custom "muted" state
// TODO: custom signals for next and previous for better osd info

Singleton {
    id: root
    readonly property MprisPlayer player: Mpris.players.values[0] ?? null
    readonly property string trackTitle: player?.trackTitle ?? ""
    readonly property bool trackHasTitle: trackTitle !== ""
    readonly property string artist: player?.trackArtist ?? ""
    readonly property bool isPlaying: player?.playbackState === MprisPlaybackState.Playing
    readonly property string icon: isPlaying ? "󰐊" : "󰏤"
    readonly property real volume: isMuted ? mutedVolume : player?.volume
    property bool skipNextVolumeUpdate: false
    property bool isMuted: false
    property real mutedVolume

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

    function toggleMute() {
        if (player === null)
            return;

        if (isMuted) {
            isMuted = false;
            player.volume = mutedVolume;
        } else {
            isMuted = true;
            mutedVolume = player.volume;
            player.volume = 0.0;
        }

        volumeUpdate();
    }

    function wheelAction(event: WheelEvent) {
        if (player === null)
            return;

        const base_increment = 0.01;
        const increment = event.angleDelta.y < 0 ? -base_increment : base_increment;
        _incrementVolume(increment);
    }

    function _incrementVolume(increment) {
        const incremented = _cleanVolume(volume + increment);
        if (isMuted) {
            mutedVolume = incremented;
            volumeUpdate();
        } else if (volume === incremented) {
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

            if (isMuted) {
                player.volume = 0.0;
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

    IpcHandler {
        target: "mpris"

        function increase_volume(): void {
            root._incrementVolume(0.05);
        }

        function decrease_volume(): void {
            root._incrementVolume(-0.05);
        }

        function play_pause(): void {
            root.playPause();
        }

        function next(): void {
            root.next();
        }

        function previous(): void {
            root.prev();
        }

        function toggle_mute(): void {
            root.toggleMute();
        }
    }
}
