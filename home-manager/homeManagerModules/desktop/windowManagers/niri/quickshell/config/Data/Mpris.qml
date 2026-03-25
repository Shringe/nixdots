pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

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
    property real mutedVolume: 0.0
    property MprisLoopState lastLoopState

    signal volumeUpdate
    signal playPauseUpdate
    signal trackUpdate

    function playPause() {
        if (player === null || !player.canControl || !player.canTogglePlaying)
            return;
        player.togglePlaying();
    }

    function next() {
        if (player === null || !player.canControl || !player.canGoNext)
            return;
        player.next();
    }

    function prev() {
        if (player === null || !player.canControl || !player.canGoPrevious)
            return;
        player.previous();
    }

    function stop() {
        if (player === null || !player.canControl)
            return;
        player.stop();
    }

    function toggleMute() {
        if (player === null || !player.canControl || !player.volumeSupported)
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

    function toggleShuffle() {
        if (player === null || !player.canControl || !player.shuffleSupported)
            return;
        player.shuffle = !player.shuffle;
    }

    function toggleLoop(loop) {
        if (player === null || !player.canControl || !player.loopSupported)
            return;

        switch (loop) {
        case "track":
            player.loopState = MprisLoopState.Track;
            break;
        case "playlist":
            player.loopState = MprisLoopState.Playlist;
            break;
        case "none":
            if (player.loopState === MprisLoopState.None) {
                player.loopState = lastLoopState ?? MprisLoopState.Playlist;
            } else {
                lastLoopState = player.loopState;
                player.loopState = MprisLoopState.None;
            }
            break;
        }
    }

    function wheelAction(event: WheelEvent) {
        if (player === null)
            return;

        const base_increment = 0.01;
        const increment = event.angleDelta.y < 0 ? -base_increment : base_increment;
        _incrementVolume(increment);
    }

    function _incrementVolume(increment) {
        if (player === null || !player.canControl || !player.volumeSupported)
            return;

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

        function toggle_shuffle(): void {
            root.toggleShuffle();
        }

        function toggle_loop(loop: string): void {
            root.toggleLoop(loop.toLowerCase());
        }
    }
}
