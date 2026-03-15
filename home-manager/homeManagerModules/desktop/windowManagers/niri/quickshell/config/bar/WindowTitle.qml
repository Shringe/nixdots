import ".."

Stext {
    anchors.verticalCenter: parent.verticalCenter
    required property var niri
    text: niri.focusedWindow?.title ?? ""
}
