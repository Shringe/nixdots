import QtQuick
import Quickshell
import Quickshell.Io
import "../.."
import "../../.."
import ".."
import "../utils"

Row {
    anchors.verticalCenter: parent.verticalCenter

    property bool laptop: false

    property real cpuPercent: 0
    property real ramPercent: 0
    property real batteryPercent: 0
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
            const isFullReload = ticksSinceLastFullReload > 3;
            const isLaptop = laptop && batteryLoader.item;
            if (isFullReload) {
                ticksSinceLastFullReload = 0;
                cpuFile.reload();
                ramFile.reload();
                if (isLaptop)
                    batteryLoader.item.capacityFile.reload();
            } else {
                ticksSinceLastFullReload += 1;
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

            const diffIdle = totalIdle - prevCpuIdle;
            const diffTotal = total - prevCpuTotal;
            cpuPercent = Math.round((1 - diffIdle / diffTotal) * 100);

            prevCpuIdle = totalIdle;
            prevCpuTotal = total;
        }
    }

    FileView {
        id: ramFile
        path: "/proc/meminfo"
        onTextChanged: {
            const lines = ramFile.text().split("\n");
            const total = parseInt(lines.find(l => l.startsWith("MemTotal:")).split(/\s+/)[1]);
            const available = parseInt(lines.find(l => l.startsWith("MemAvailable:")).split(/\s+/)[1]);
            ramPercent = Math.round((1 - available / total) * 100);
        }
    }

    Loader {
        id: batteryLoader
        active: laptop
        sourceComponent: Row {
            property alias capacityFile: batteryCapacityFile
            property alias statusFile: batteryStatusFile
            FileView {
                id: batteryCapacityFile
                path: "/sys/class/power_supply/BAT0/capacity"
                onTextChanged: {
                    batteryPercent = parseInt(batteryCapacityFile.text().trim());
                }
            }
            FileView {
                id: batteryStatusFile
                path: "/sys/class/power_supply/BAT0/status"
                onTextChanged: {
                    const status = batteryStatusFile.text().trim();
                    batteryCharging = (status === "Charging" || status === "Full");
                }
            }

            Stext {
                text: batteryPercent + "%"
            }

            TextIcon {
                icon: batteryPercent > 90 ? "" : batteryPercent > 60 ? "" : batteryPercent > 40 ? "" : batteryPercent > 20 ? "" : ""
                label.color: batteryCharging ? Config.colors.base0C : batteryPercent > 40 ? Config.colors.base05 : batteryPercent > 20 ? Config.colors.base0A : Config.colors.base08
                lpad: 4
                rpad: 8
            }
        }
    }

    Stext {
        text: ramPercent + "%"
    }
    TextIcon {
        icon: ""
        lpad: 4
        rpad: 8
    }

    Stext {
        text: cpuPercent + "%"
    }
    TextIcon {
        icon: ""
        lpad: 4
    }
}
