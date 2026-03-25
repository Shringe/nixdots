import QtQuick
import Quickshell
import Quickshell.Widgets

import qs.inner.bar.utils
import qs.inner.bar
import qs.inner
import qs
import qs.inner.Data as Dat

Row {
    id: root

    required property PanelWindow trunk

    WrapperMouseArea {
        id: mouseArea
        hoverEnabled: true

        onEntered: {
            dropdown.open();
        }

        onExited: {
            dropdown.close();
        }

        TextIcon {
            icon: "󰑊"
        }
    }

    Dropdown {
        id: dropdown
        trunk: root.trunk
        boxParent: mouseArea

        Rectangle {
            width: text.width + Config.borders.radius
            height: text.height + Config.borders.radius
            color: Config.colors.base00
            radius: Config.borders.radius

            Stext {
                id: text
                text: Dat.Privacy.getPrivacySummary()
                anchors.centerIn: parent
            }
        }
    }
}
