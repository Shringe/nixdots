pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs

Singleton {
    id: root

    readonly property bool laptop: Config.hardware.isLaptop

    readonly property QtObject battery: QtObject {
        property real percent: 100.0
        property bool charging: false
        readonly property string icon: percent > 90 ? "" : percent > 60 ? "" : percent > 40 ? "" : percent > 20 ? "" : ""
        readonly property color color: charging ? Config.colors.base0C : percent > 40 ? Config.colors.base05 : percent > 20 ? Config.colors.base0A : Config.colors.base08

        readonly property real lowThreshold: 20.0
        readonly property real reliefThreshold: lowThreshold * 1.1
        readonly property bool low: percent < lowThreshold ? true : percent > reliefThreshold ? false : low
    }

    readonly property QtObject memory: QtObject {
        property real percent: 0.0
        readonly property string icon: ""

        readonly property real lowThreshold: 80.0
        readonly property real reliefThreshold: lowThreshold * 0.9
        readonly property bool low: percent > lowThreshold ? true : percent < reliefThreshold ? false : low
    }

    readonly property QtObject cpu: QtObject {
        property real percent: 0.0
        readonly property string icon: ""

        readonly property real lowThreshold: 90.0
        readonly property real reliefThreshold: lowThreshold * 0.9
        readonly property bool low: percent > lowThreshold ? true : percent < reliefThreshold ? false : low

        // Previous CPU stats for delta calculation
        property int _prevIdle: 0
        property int _prevTotal: 0
    }

    // A full reload happens every fifth tick, and a partial reload happens every tick
    property int _ticksSinceLastFullReload: 0

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            const isFullReload = root._ticksSinceLastFullReload > 3;
            const isLaptop = root.laptop && batteryLoader.item;
            if (isFullReload) {
                root._ticksSinceLastFullReload = 0;
                cpuFile.reload();
                ramFile.reload();
                if (isLaptop)
                    batteryLoader.item.capacityFile.reload();
            } else {
                root._ticksSinceLastFullReload += 1;
            }

            if (isLaptop)
                batteryLoader.item.statusFile.reload();
        }
    }

    FileView {
        id: cpuFile
        path: "/proc/stat"
        onTextChanged: {
            const line = cpuFile.text().split("\n").find(l => l.startsWith("cpu "));
            if (!line)
                return;

            const parts = line.trim().split(/\s+/);
            const user = parseInt(parts[1]);
            const nice = parseInt(parts[2]);
            const system = parseInt(parts[3]);
            const idle = parseInt(parts[4]);
            const iowait = parseInt(parts[5]);
            const irq = parseInt(parts[6]);
            const softirq = parseInt(parts[7]);

            const totalIdle = idle + iowait;
            const totalBusy = user + nice + system + irq + softirq;
            const total = totalIdle + totalBusy;

            const diffIdle = totalIdle - root.cpu._prevIdle;
            const diffTotal = total - root.cpu._prevTotal;
            root.cpu.percent = Math.round((1 - diffIdle / diffTotal) * 100);

            root.cpu._prevIdle = totalIdle;
            root.cpu._prevTotal = total;
        }
    }

    FileView {
        id: ramFile
        path: "/proc/meminfo"
        onTextChanged: {
            const lines = ramFile.text().split("\n");
            const total = parseInt(lines.find(l => l.startsWith("MemTotal:")).split(/\s+/)[1]);
            const available = parseInt(lines.find(l => l.startsWith("MemAvailable:")).split(/\s+/)[1]);
            root.memory.percent = Math.round((1 - available / total) * 100);
        }
    }

    Loader {
        id: batteryLoader
        active: root.laptop
        sourceComponent: Item {
            property alias capacityFile: batteryCapacityFile
            property alias statusFile: batteryStatusFile
            FileView {
                id: batteryCapacityFile
                path: "/sys/class/power_supply/BAT0/capacity"
                onTextChanged: {
                    root.battery.percent = parseInt(batteryCapacityFile.text().trim());
                }
            }
            FileView {
                id: batteryStatusFile
                path: "/sys/class/power_supply/BAT0/status"
                onTextChanged: {
                    const status = batteryStatusFile.text().trim();
                    root.battery.charging = (status === "Charging" || status === "Full");
                }
            }
        }
    }
}
