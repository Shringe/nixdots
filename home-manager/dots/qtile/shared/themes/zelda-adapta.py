# Auto-generated theme configuration
from shared.themes.Theme import Theme, ThemeColors, ThemeIcons
from os.path import expanduser

theme = Theme(
    colors=ThemeColors(
        top_gradient="#9EA4A9",
        bottom_gradient="#798798",
        text_highlight="#1ce8ff",
        active_highlight="#1028ff",
        group_background="#141313",
        textbox_background="#9EA4A9",
        vpn_background="#58768C",
        volume_background="#FF6F61",
        network_background="#141213",
        memory_background="#65794E",
        cpu_background="#008080",
        clock_background="#a09187",
        bar_background="#00000000",
        border_active="#1ce8ff",
        border_inactive="#008080",
    ),
    icons=ThemeIcons(
        memory_usage="memory",
        vpn_active="nordvpn_active",
        vpn_inactive="nordvpn_inactive",
        groups_logo="arch_logo",
        icon_path=expanduser("~/.config/dotfiles/qtile/shared/themes/icons"),
    ),
    wallpaper="anime-botw-link",
    wallpaper_dir=expanduser("~/.config/wallpapers"),
)
