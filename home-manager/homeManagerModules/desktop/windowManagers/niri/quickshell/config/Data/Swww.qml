pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import qs

Singleton {
    id: root

    readonly property list<string> extra_args: ["-f", "Nearest"]
    // Supported:           none | simple | fade | left | right | top | bottom | wipe | wave | grow | center | any | outer
    // We do our own randomization instead of using "random" so that I'm able to exclude certain effects like "none"
    property list<string> transition_effects: ["grow", "wipe", "center", "outer", "wave", "fade"]

    // Cycling wallpapers - json fields
    property list<string> output: []
    property list<int> fps: []
    property list<int> interval: []
    // Split by "||"
    property list<string> cycle: []

    // Cycling wallpapers - extra fields
    // The current wallpaper that is active
    property list<int> cycleIndex: []
    // The timestamp of the last cycle. Real is used because int overflows
    property list<real> lastCycle: []
    // The index of next monitor that needs to cycle
    property int nextCycleIndex: 0
    // Queue of JSON paths waiting to be loaded sequentially through the shared FileView
    property list<string> loadQueue: []
    property bool loading: false

    function swww(args) {
        const cmd = [Config.dependencies.swww, ...args];
        Quickshell.execDetached(cmd);
    }

    function _setImg(path: string, output: string, fps: int) {
        console.info(`Setting wallpaper on ${output} as ${path}`);
        const effect = getEffect();
        console.debug("Transition effect:", effect);
        const args = ["img", path, "--outputs", output, "--transition-fps", fps, "--transition-type", effect, ...extra_args];
        swww(args);
    }

    function img(wallpaper: string, output: string, fps: int) {
        if (wallpaper.endsWith(".json")) {
            if (root.loading) {
                loadQueue.push(wallpaper);
            } else {
                loading = true;
                wallpaperJson.path = wallpaper;
            }
        } else {
            _setImg(wallpaper, output, fps);
        }
    }

    // Chooses a random effect
    function getEffect() {
        // Take from the front of the deck
        const effect = transition_effects[0];

        // Move it to the back, then shuffle the last two thirds
        const deck = [...transition_effects.slice(1), effect];
        transition_effects = shuffle(deck, Math.floor(deck.length / 3));

        return effect;
    }

    // Shuffles an array, starting from index `from`
    function shuffle(arr, from = 0) {
        for (let i = arr.length - 1; i > from; i--) {
            const j = Math.floor(Math.random() * (i - from + 1)) + from;
            [arr[i], arr[j]] = [arr[j], arr[i]];
        }
        return arr;
    }

    // Find the monitor that needs to cycle soonest and arm the timer for it
    function _scheduleNext() {
        if (root.output.length === 0) {
            cycleTimer.stop();
            return;
        }

        let nearest = -1;
        let nearestTime = Infinity;

        for (let i = 0; i < root.output.length; i++) {
            const nextCycle = root.lastCycle[i] + root.interval[i] * 1000 * 60;
            if (nextCycle < nearestTime) {
                nearestTime = nextCycle;
                nearest = i;
            }
        }

        const delay = Math.max(0, nearestTime - Date.now());
        root.nextCycleIndex = nearest;
        cycleTimer.interval = delay;
        cycleTimer.restart();
    }

    Timer {
        id: cycleTimer

        repeat: false

        onTriggered: {
            const i = root.nextCycleIndex;
            const cycles = root.cycle[i].split("||");

            // Advance and display
            root.cycleIndex[i] = (root.cycleIndex[i] + 1) % cycles.length;
            root.lastCycle[i] = Date.now();
            root._setImg(cycles[root.cycleIndex[i]], root.output[i], root.fps[i]);

            root._scheduleNext();
        }
    }

    FileView {
        id: wallpaperJson

        onPathChanged: wallpaperJson.reload()
        onLoaded: {
            let data;
            try {
                data = JSON.parse(wallpaperJson.text());
            } catch (e) {
                console.error("Failed to parse wallpaper JSON:", wallpaperJson.path, e);
                return;
            }

            const {
                output,
                fps,
                folder
            } = data;

            if ("static" in data) {
                // Remove this output from cycling arrays if it was previously cycling
                const i = root.output.indexOf(output);
                if (i !== -1) {
                    root.output.splice(i, 1);
                    root.fps.splice(i, 1);
                    root.interval.splice(i, 1);
                    root.cycle.splice(i, 1);
                    root.cycleIndex.splice(i, 1);
                    root.lastCycle.splice(i, 1);
                    root._scheduleNext();
                }
                root._setImg(`${folder}/${data.static}`, output, fps);
            } else if ("cycle" in data) {
                if (root.output.length === 0) {
                    root.transition_effects = shuffle(root.transition_effects);
                }

                const cycleStr = data.cycle.map(c => `${folder}/${c}`).join("||");
                const now = Date.now();
                const intervalMs = data.interval * 60 * 1000;
                // Offsets so monitors are unlikely to cycle simultaneously
                const randomOffset = Math.random() * 300;
                const indexOffset = root.output.length * 3141;

                // Update in place if this output is already registered, otherwise append
                const i = root.output.indexOf(output);
                if (i !== -1) {
                    root.fps[i] = fps;
                    root.interval[i] = data.interval;
                    root.cycle[i] = cycleStr;
                } else {
                    root.output.push(output);
                    root.fps.push(fps);
                    root.interval.push(data.interval);
                    root.cycle.push(cycleStr);
                    root.cycleIndex.push(0);
                    root.lastCycle.push(now - randomOffset + indexOffset);
                }

                // Show the first image immediately and schedule the timer
                root._setImg(cycleStr.split("||")[0], output, fps);
                root._scheduleNext();
            } else {
                console.error("Wallpaper JSON has neither 'static' nor 'cycle' key:", wallpaperJson.path);
            }

            loadNextTimer.start();
        }
    }

    Timer {
        id: loadNextTimer

        interval: 0
        repeat: false

        onTriggered: {
            if (root.loadQueue.length > 0) {
                wallpaperJson.path = root.loadQueue.shift();
            } else {
                root.loading = false;
            }
        }
    }
}
