pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.inner.Data as Dat

Singleton {
    id: root

    property list<int> bars
    readonly property list<int> _bars: Array.from({
        length: 16
    }, () => 1)

    Connections {
        target: Dat.Session
        function onDrawAnimationFrame() {
            root.bars = root._bars;
        }
    }

    Process {
        id: cavaProc
        command: ["cava", "-p", Quickshell.shellDir + "/inner/Data/cavaconfig"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                const values = line.trim().split(";").filter(v => v !== "");
                const bars = values.map(v => parseInt(v));

                if (values.length !== 0 && bars != root._bars) {
                    root._bars = bars;
                }
            }
        }
    }
}
