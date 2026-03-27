import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../.."
import "../../.."
import ".."
import "../utils"
import qs.inner.Data as Dat

StyledDropdown {
    id: root

    readonly property bool anyLow: Dat.Hardware.memory.low || Dat.Hardware.cpu.low || Dat.Hardware.battery.low

    triggerContent: Row {
        anchors.verticalCenter: parent.verticalCenter

        Connections {
            target: root
            function onAnyLowChanged() {
                if (root.anyLow)
                    root.dropdown.propOpen(5000);
            }
        }

        Loader {
            active: Dat.Hardware.laptop
            sourceComponent: Row {
                Stext {
                    text: Dat.Hardware.battery.percent + "%"
                }

                TextIcon {
                    icon: Dat.Hardware.battery.icon
                    label.color: Dat.Hardware.battery.color
                    lpad: 4
                    rpad: 8
                }
            }
        }

        Stext {
            text: Dat.Hardware.memory.percent + "%"
        }
        TextIcon {
            icon: Dat.Hardware.memory.icon
            lpad: 4
            rpad: 8
        }

        Stext {
            text: Dat.Hardware.cpu.percent + "%"
        }
        TextIcon {
            icon: Dat.Hardware.cpu.icon
            lpad: 4
        }
    }

    dropdownContent: ColumnLayout {
        spacing: 2

        Stext {
            Layout.alignment: Qt.AlignHCenter
            visible: Dat.Hardware.memory.low
            text: "Device is low on RAM!"
        }

        Stext {
            Layout.alignment: Qt.AlignHCenter
            visible: Dat.Hardware.cpu.low
            text: "Device is is low on CPU!"
        }

        Stext {
            Layout.alignment: Qt.AlignHCenter
            visible: Dat.Hardware.battery.low
            text: "Device is is low on battery!"
        }
    }
}
