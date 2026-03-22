import "../.."

Stext {
    required property var niri
    text: niri.focusedWindow?.title ?? ""
}
