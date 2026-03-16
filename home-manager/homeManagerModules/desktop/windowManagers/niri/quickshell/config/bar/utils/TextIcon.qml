import QtQuick
import ".."
import "../.."
import "bar"

Row {
    required property string icon
    property int lpad: 0
    property int rpad: 0
    property alias label: iconText

    Spacer {
        width: lpad
    }
    Stext {
        id: iconText
        text: icon
    }
    Spacer {
        width: rpad
    }
}
