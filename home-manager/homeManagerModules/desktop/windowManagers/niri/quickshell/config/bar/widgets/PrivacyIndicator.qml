import qs.inner.bar.utils
import qs.inner.bar
import qs.inner
import qs.inner.Data as Dat

StyledDropdown {
    triggerContent: TextIcon {
        icon: "󰑊"
    }

    dropdownContent: Stext {
        text: Dat.Privacy.getPrivacySummary()
    }
}
