from libqtile.config import Screen
from libqtile import bar
from qtile_extras import widget
from shared.widgets.NordVPN import NordVPN
from shared.widgets.NetDisplay import NetDisplay
from qtile_extras.widget import modify
from libqtile.lazy import lazy
from shared.utils.format import format_tui
from x11.defaults import apps, theme
from x11.display import decorations


widget_defaults = dict(
    font="FontAwesome",
    fontsize=14,
    padding=2,
    update_interval=2,
    icon_size=10,
)

outerScreenGap: int = 1

primary = Screen(
    top=bar.Bar(
        [
            widget.Image(
                filename=theme.icons.groups_logo,
                background=theme.colors.group_background,
                margin_y=1,
            ),
            widget.GroupBox(
                highlight_color=[
                    theme.colors.top_gradient,
                    theme.colors.bottom_gradient,
                ],
                block_highlight_text_color=theme.colors.text_highlight,
                highlight_method="line",
                active=theme.colors.active_highlight,
                disable_drag=True,
                background=theme.colors.group_background,
                **decorations.powerline_left,
            ),
            widget.TextBox(
                background=theme.colors.textbox_background,
                fmt="➡",
                **decorations.powerline_left,
            ),
            widget.WindowName(**decorations.powerline_right),
            widget.Systray(icon_size=22, **decorations.powerline_right),
            widget.Image(
                name="nordvpn_icon",
                filename=theme.icons.vpn_active,
                mouse_callbacks={"Button2": NordVPN.disableNord},
                margin_y=3,
                margin_x=0,
                background=theme.colors.vpn_background,
            ),
            modify(
                NordVPN,
                theme.icons.vpn_inactive,
                theme.icons.vpn_active,
                mouse_callbacks={"Button2": NordVPN.disableNord},
                update_interval=4,
                background=theme.colors.vpn_background,
                **decorations.powerline_zig_zag,
            ),
            widget.PulseVolume(
                emoji=True,
                padding=1,
                background=theme.colors.volume_background,
                **decorations.powerline_zig_zag,
            ),
            modify(
                NetDisplay,
                format="⬇{}/⬆{}",
                update_interval=2,
                background=theme.colors.network_background,
                **decorations.powerline_zig_zag,
            ),
            widget.Image(
                filename=theme.icons.memory_usage,
                margin_y=1,
                margin_x=0,
                background=theme.colors.memory_background,
            ),
            widget.Memory(
                format="{MemPercent:.0f}%",
                background=theme.colors.memory_background,
                **decorations.powerline_zig_zag,
            ),
            widget.CPU(
                format="  {load_percent:.0f}%",
                background=theme.colors.cpu_background,
                mouse_callbacks={
                    "Button1": lazy.spawn(format_tui("btop", apps.terminal)),
                    "Button2": lazy.spawn(format_tui("nvtop", apps.terminal)),
                    "Button3": lazy.spawn(format_tui("htop", apps.terminal)),
                },
                **decorations.powerline_zig_zag,
            ),
            widget.Clock(
                format="󰥔  %Y-%m-%d %a %I:%M %p",
                background=theme.colors.clock_background,
                mouse_callbacks={
                    "Button1": lazy.group["0"].dropdown_toggle("khal"),
                },
            ),
        ],
        22,
        background=theme.colors.bar_background,
    ),
    bottom=bar.Gap(outerScreenGap),
    right=bar.Gap(outerScreenGap),
    left=bar.Gap(outerScreenGap),
    wallpaper=theme.wallpaper,
    wallpaper_mode="fill",
    x11_drag_polling_rate=165,
)

# setting top gap
primary.top.margin: list = [0, 0, outerScreenGap, 0]


# secondary = Screen(
#    top=bar.Bar(
#        [
#            widget.Spacer(length=2, background=theme.colors.colors[1]),  # leftside padding
#            widget.CurrentLayout(background=theme.colors.colors[1], **decorations.powerline_zig_zag),
#            widget.Image(
#                name="nordvpn_icon",
#                filename=theme.icons["nord-inactive-small"],
#                mouse_callbacks={"Button2": NordVPN.disableNord},
#                margin_y=3,
#                margin_x=0,
#                background=theme.colors.colors[9],
#            ),
#            modify(
#                NordVPN,
#                theme.icons["nord-inactive-small"],
#                theme.icons["nord-active-small"],
#                mouse_callbacks={"Button2": NordVPN.disableNord},
#                update_interval=4,
#                background=theme.colors.colors[9],
#                **decorations.powerline_zig_zag,
#            ),
#            widget.Clock(
#                format="󰥔  %Y-%m-%d %a %I:%M %p",
#                background=theme.colors.colors[8],
#                **decorations.powerline_left,
#            ),
#            widget.Spacer(**decorations.powerline_right),
#            widget.NvidiaSensors(
#                format="GPU {temp}°C",
#                background=theme.colors.colors[3],
#                **decorations.powerline_right,
#            ),
#            widget.ThermalSensor(
#                format="CPU {temp:.0f}°C",
#                tag_sensor="Tdie",
#                background=theme.colors.colors[13],
#                **decorations.powerline_right,
#            ),
#            widget.Image(
#                filename=theme.icons["memory2"],
#                margin_y=1,
#                margin_x=0,
#                background=theme.colors.colors[3],
#            ),
#            widget.Memory(
#                format="{MemPercent:.0f}%",
#                background=theme.colors.colors[3],
#                **decorations.powerline_right,
#            ),
#            widget.CPU(format="  {load_percent:.0f}%", background=theme.colors.colors[13]),
#            # widget.WindowName(**decorations.powerline_right),
#            # widget.Systray(),
#        ],
#        24,
#        background=theme.colors.colors[10],
#    )
# )


screens = [primary]
