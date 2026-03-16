import QtQuick
import Quickshell
import Quickshell.Io
import "../.."
import ".."
import "../utils"

Row {
    anchors.verticalCenter: parent.verticalCenter

    property real cpuPercent: 0
    property real ramPercent: 0

    // Previous CPU stats for delta calculation
    property var prevCpu: null

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            cpuFile.reload();
            ramFile.reload();
        }
    }

    FileView {
        id: cpuFile
        path: "/proc/stat"
        onTextChanged: {
            var line = cpuFile.text().split("\n").find(l => l.startsWith("cpu "));
            if (!line)
                return;
            var parts = line.trim().split(/\s+/);
            var user = parseInt(parts[1]);
            var nice = parseInt(parts[2]);
            var system = parseInt(parts[3]);
            var idle = parseInt(parts[4]);
            var iowait = parseInt(parts[5]);
            var irq = parseInt(parts[6]);
            var softirq = parseInt(parts[7]);

            var totalIdle = idle + iowait;
            var totalBusy = user + nice + system + irq + softirq;
            var total = totalIdle + totalBusy;

            if (prevCpu) {
                var diffIdle = totalIdle - prevCpu.idle;
                var diffTotal = total - prevCpu.total;
                cpuPercent = Math.round((1 - diffIdle / diffTotal) * 100);
            }

            prevCpu = {
                idle: totalIdle,
                total: total
            };
        }
    }

    FileView {
        id: ramFile
        path: "/proc/meminfo"
        onTextChanged: {
            var lines = ramFile.text().split("\n");
            var total = parseInt(lines.find(l => l.startsWith("MemTotal:")).split(/\s+/)[1]);
            var available = parseInt(lines.find(l => l.startsWith("MemAvailable:")).split(/\s+/)[1]);
            ramPercent = Math.round((1 - available / total) * 100);
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
