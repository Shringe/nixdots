pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property list<int> bars: Array.from({
        length: 16
    }, () => 1)

    Process {
        id: cavaProc
        command: ["cava", "-p", Quickshell.shellDir + "/inner/Data/cavaconfig"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                const values = line.trim().split(";").filter(v => v !== "");
                if (values.length !== 0)
                    root.bars = values.map(v => parseInt(v));
            }
        }
    }
}
