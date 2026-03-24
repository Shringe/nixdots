import "../.."
import qs.inner.Data as Dat

Stext {
    text: Dat.Session.niri.focusedWindow?.title ?? ""
}
