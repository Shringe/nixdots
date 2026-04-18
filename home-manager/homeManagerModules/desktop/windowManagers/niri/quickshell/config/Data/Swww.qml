pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import qs

Singleton {
    id: root

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
    // The shuffle type. "none", "first", or "always"
    property list<string> cycleShuffle: []
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

        let filter = "Nearest";
        let wallpaper = path;
        const match = path.match(/<(.+)>$/);
        if (match !== null) {
            filter = match[1];
            wallpaper = path.substring(0, path.length - filter.length - 2);
        }

        const args = ["img", wallpaper, "--outputs", output, "--transition-fps", fps, "--transition-type", effect, "--filter", filter];
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
        transition_effects = root.shuffle(deck, Math.floor(deck.length / 3));

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
        console.debug(`Next cycle in ${root.msToHumanTime(delay)}`);
    }

    function msToHumanTime(ms) {
        // Convert milliseconds to total seconds
        const totalSeconds = Math.floor(ms / 1000);

        // Extract hours, minutes, and seconds
        const hours = Math.floor(totalSeconds / 3600);
        const minutes = Math.floor((totalSeconds % 3600) / 60);
        const seconds = totalSeconds % 60;

        // Build the parts array with only non-zero values
        const parts = [];
        if (hours > 0)
            parts.push(`${hours} ${hours === 1 ? "hour" : "hours"}`);
        if (minutes > 0)
            parts.push(`${minutes} ${minutes === 1 ? "minute" : "minutes"}`);
        if (seconds > 0 || parts.length === 0)
            parts.push(`${seconds} ${seconds === 1 ? "second" : "seconds"}`);

        // Join parts with commas and "and" before the last element
        if (parts.length === 1)
            return parts[0];
        return `${parts.slice(0, -1).join(", ")} and ${parts[parts.length - 1]}`;
    }

    function setCycleWallpaper(cycles, i: int) {
        let shuffled;
        if (root.cycleShuffle[i] === "always") {
            shuffled = root.shuffle(cycles);
            root.cycle[i] = shuffled.join("||"); // Saving the shuffled state increases variance
        } else {
            shuffled = cycles;
        }

        root._setImg(cycles[root.cycleIndex[i]], root.output[i], root.fps[i]);
    }

    // Skip over to the next wallpaper
    function next(output = "") {
        let i;
        if (output === "") {
            i = root.nextCycleIndex;
        } else {
            i = root.output.indexOf(output);
            if (i === -1) {
                console.error(`Can't skip ${output} becuase it doesn't appear to be cycling`);
                i = root.nextCycleIndex;
            }
        }

        const cycles = root.cycle[i].split("||");
        root.cycleIndex[i] = (root.cycleIndex[i] + 1) % cycles.length;
        root.lastCycle[i] = (root.lastCycle[i] + root.interval[i] * 60000);
        root.setCycleWallpaper(cycles, i);
        root._scheduleNext();
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
            root.setCycleWallpaper(cycles, i);
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
                    root.cycleShuffle.splice(i, 1);
                    root.lastCycle.splice(i, 1);
                    root._scheduleNext();
                }
                root._setImg(`${folder}/${data.static}`, output, fps);
            } else if ("cycle" in data) {
                if (root.output.length === 0) {
                    root.transition_effects = root.shuffle(root.transition_effects);
                }

                // Default to none
                let shuffle;
                if ("shuffle" in data) {
                    shuffle = data.shuffle;
                } else {
                    shuffle = "none";
                }

                // Shuffle the cycle first if requested
                let cycles = data.cycle;
                if (shuffle === "first" || shuffle === "always") {
                    cycles = root.shuffle(cycles);
                }

                const cycleStr = cycles.map(w => `${folder}/${w}`).join("||");
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
                    root.cycleShuffle.push(shuffle);
                } else {
                    root.output.push(output);
                    root.fps.push(fps);
                    root.interval.push(data.interval);
                    root.cycle.push(cycleStr);
                    root.cycleIndex.push(0);
                    root.cycleShuffle.push(shuffle);
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

    IpcHandler {
        target: "swww"

        function next(output: string): void {
            root.next(output);
        }
    }
}
