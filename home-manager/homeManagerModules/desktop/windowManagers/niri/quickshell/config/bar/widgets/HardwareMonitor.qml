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

    triggerContent: Row {
        anchors.verticalCenter: parent.verticalCenter

        Connections {
            target: Dat.Hardware
            function onResourceLow() {
                root.dropdown.propOpen(5000);
            }
        }

        Loader {
            active: Dat.Hardware.laptop
            sourceComponent: Row {
                Stext {
                    text: Dat.Hardware.battery.remaining + "%"
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

    horizontalPadding: verticalPadding * 2
    dropdownContent: ColumnLayout {
        spacing: 4

        Stext {
            Layout.alignment: Qt.AlignHCenter
            visible: Dat.Hardware.battery.low
            color: Config.colors.base09
            text: "Device has " + Dat.Hardware.battery.remaining + "% battery remaining"
        }

        Stext {
            Layout.alignment: Qt.AlignHCenter
            visible: Dat.Hardware.memory.low
            color: Config.colors.base0A
            text: "Device has only " + Dat.Hardware.memory.remaining + "% RAM remaining"
        }

        Stext {
            Layout.alignment: Qt.AlignHCenter
            visible: Dat.Hardware.cpu.low
            color: Config.colors.base0A
            text: "Device has only " + Dat.Hardware.cpu.remaining + "% CPU remaining"
        }
    }
}
