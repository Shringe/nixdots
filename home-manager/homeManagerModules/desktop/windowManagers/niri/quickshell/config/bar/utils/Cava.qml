import QtQuick
import Quickshell
import Quickshell.Io
import "../../.."

Row {
    anchors.verticalCenter: parent.verticalCenter
    height: 20
    spacing: 2
    topPadding: 2
    bottomPadding: 2

    property list<int> bars: Array.from({
        length: 16
    }, () => 1)

    Process {
        id: cavaProc
        command: ["cava", "-p", Quickshell.shellDir + "/inner/bar/utils/cavaconfig/config"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                var values = line.trim().split(";").filter(v => v !== "");
                if (values.length === 0)
                    return;
                bars = values.map(v => parseInt(v));
            }
        }
    }

    Repeater {
        model: bars.length

        Rectangle {
            width: 4
            height: Math.max(2, bars[index] / 50)
            anchors.bottom: parent.bottom
            color: Config.colors.base05
        }
    }
}
