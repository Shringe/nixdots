from shared.themes.Theme import Theme, ThemeIcons, ThemeColors

theme = Theme(
    icons=ThemeIcons(
        memory_usage="memory",
        vpn_active="nordvpn_active",
        vpn_inactive="nordvpn_inactive",
    ),
    colors=ThemeColors(
        top_gradient="#9EA4A9",
        bottom_gradient="#798798",
        text_highlight="#EEB539",
        active_highlight="#6E7990",
        group_background="#798798",
        textbox_background="#9EA4A9",
        vpn_background="#58768C",
        volume_background="#FF6F61",
        network_background="#4B0082",
        memory_background="#65794E",
        cpu_background="#008080",
        clock_background="#a09187",
        bar_background="#00000000",
        border_inactive="#8f3d3d",
        border_active="#d75f5f",
    ),
    wallpaper="anime-botw-link",
)
