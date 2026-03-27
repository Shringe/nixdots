import QtQuick
import Quickshell
import Quickshell.Io
import "../.."
import "../../.."
import ".."
import "../utils"
import qs.inner.Data as Dat

Row {
    anchors.verticalCenter: parent.verticalCenter

    Loader {
        active: Dat.Hardware.laptop
        sourceComponent: Row {
            Stext {
                text: Dat.Hardware.batteryPercent + "%"
            }

            TextIcon {
                icon: Dat.Hardware.batteryIcon
                label.color: Dat.Hardware.batteryColor
                lpad: 4
                rpad: 8
            }
        }
    }

    Stext {
        text: Dat.Hardware.ramPercent + "%"
    }
    TextIcon {
        icon: Dat.Hardware.ramIcon
        lpad: 4
        rpad: 8
    }

    Stext {
        text: Dat.Hardware.cpuPercent + "%"
    }
    TextIcon {
        icon: Dat.Hardware.cpuIcon
        lpad: 4
    }
}
