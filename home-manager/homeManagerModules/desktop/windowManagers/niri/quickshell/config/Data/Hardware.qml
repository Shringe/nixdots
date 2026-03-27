pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs

Singleton {
    id: root

    readonly property bool laptop: Config.hardware.isLaptop

    readonly property string cpuIcon: ""
    readonly property string ramIcon: ""
    readonly property string batteryIcon: batteryPercent > 90 ? "" : batteryPercent > 60 ? "" : batteryPercent > 40 ? "" : batteryPercent > 20 ? "" : ""
    readonly property color batteryColor: batteryCharging ? Config.colors.base0C : batteryPercent > 40 ? Config.colors.base05 : batteryPercent > 20 ? Config.colors.base0A : Config.colors.base08

    property real cpuPercent: 0.0
    property real ramPercent: 0.0
    property real batteryPercent: 0.0
    property bool batteryCharging: false

    // Previous CPU stats for delta calculation
    property int prevCpuIdle: 0
    property int prevCpuTotal: 0
    // A full reload happens every fifth tick, and a partial reload happens every tick
    property int ticksSinceLastFullReload: 0

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            const isFullReload = root.ticksSinceLastFullReload > 3;
            const isLaptop = root.laptop && batteryLoader.item;
            if (isFullReload) {
                root.ticksSinceLastFullReload = 0;
                cpuFile.reload();
                ramFile.reload();
                if (isLaptop)
                    batteryLoader.item.capacityFile.reload();
            } else {
                root.ticksSinceLastFullReload += 1;
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

            const diffIdle = totalIdle - root.prevCpuIdle;
            const diffTotal = total - root.prevCpuTotal;
            root.cpuPercent = Math.round((1 - diffIdle / diffTotal) * 100);

            root.prevCpuIdle = totalIdle;
            root.prevCpuTotal = total;
        }
    }

    FileView {
        id: ramFile
        path: "/proc/meminfo"
        onTextChanged: {
            const lines = ramFile.text().split("\n");
            const total = parseInt(lines.find(l => l.startsWith("MemTotal:")).split(/\s+/)[1]);
            const available = parseInt(lines.find(l => l.startsWith("MemAvailable:")).split(/\s+/)[1]);
            root.ramPercent = Math.round((1 - available / total) * 100);
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
                    root.batteryPercent = parseInt(batteryCapacityFile.text().trim());
                }
            }
            FileView {
                id: batteryStatusFile
                path: "/sys/class/power_supply/BAT0/status"
                onTextChanged: {
                    const status = batteryStatusFile.text().trim();
                    root.batteryCharging = (status === "Charging" || status === "Full");
                }
            }
        }
    }
}
