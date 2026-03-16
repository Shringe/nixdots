import QtQuick
import Quickshell
import Quickshell.Io
import "../.."
import ".."
import "../utils"

Row {
    anchors.verticalCenter: parent.verticalCenter

    property real cpuUsage: 0
    property real ramUsage: 0

    // Previous CPU stats for delta calculation
    property var prevCpu: null

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true;
            ramProc.running = true;
        }
    }

    Process {
        id: cpuProc
        command: ["cat", "/proc/stat"]
        stdout: SplitParser {
            onRead: function (line) {
                if (!line.startsWith("cpu "))
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
                    cpuUsage = Math.round((1 - diffIdle / diffTotal) * 100);
                }

                prevCpu = {
                    idle: totalIdle,
                    total: total
                };
            }
        }
    }

    Process {
        id: ramProc
        command: ["cat", "/proc/meminfo"]
        stdout: SplitParser {
            onRead: function (line) {
                if (line.startsWith("MemTotal:"))
                    ramProc.memTotal = parseInt(line.trim().split(/\s+/)[1]);
                else if (line.startsWith("MemAvailable:")) {
                    var available = parseInt(line.trim().split(/\s+/)[1]);
                    ramUsage = Math.round((1 - available / ramProc.memTotal) * 100);
                }
            }
        }
        property int memTotal: 0
    }

    Stext {
        text: ""
    }
    Spacer {
        width: 5
    }
    Stext {
        text: cpuUsage + "%"
    }
    Spacer {
        width: 10
    }
    Stext {
        text: ""
    }
    Spacer {
        width: 5
    }
    Stext {
        text: ramUsage + "%"
    }
    Stext {
        text: ""
    }
}
