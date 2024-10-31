from re import compile

from libqtile import layout
from libqtile.config import DropDown, Group, Match, ScratchPad
from x11.defaults import theme

from shared.defaults import apps
from shared.utils.format import format_tui

active = theme.colors.border_active
inactive = theme.colors.border_inactive

# Layouts
Columns = layout.Columns(
    border_focus_stack=[active, inactive],
    single_border_width=10,
    single_margin=0,
    margin=2,
    border_width=0,
)

MonadTall = layout.MonadTall(
    border_focus=active,
    border_normal=inactive,
    single_border_width=0,
    single_margin=2,
    margin=2,
    border_width=2,
)

VerticalTile = layout.VerticalTile(
    border_focus=active,
    border_normal=inactive,
    single_margin=0,
    margin=2,
    border_width=0,
)

Max = layout.Max()


Floating = layout.Floating(
    float_rules=[
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(wm_class="lxqt-policykit-agent"),
        Match(title=compile(r".*Extension.*")),
        Match(wm_class="pinentry-gtk"),  # GPG key password entry
    ],
    border_focus=active,
    border_normal=inactive,
    margin=1,
)

primary = MonadTall
floating = Floating

# Groups
groups: list = [
    Group("1", layouts=[primary]),
    # Group(
    #     "2",
    #     layouts=[VerticalTile],
    #     matches=[Match(wm_class="strawberry"), Match(wm_class="tidal-hifi")],
    # ),
    Group("2", layouts=[primary]),
    Group("3", layouts=[primary]),
    Group("4", layouts=[primary]),
    Group("5", layouts=[primary]),
    Group("6", layouts=[primary]),
    Group("7", layouts=[primary]),
    Group("8", layouts=[primary]),
    Group("9", layouts=[primary], spawn=f"{apps.terminal} --working-directory /nixdots"),
    ScratchPad(
        "0",
        [
            DropDown(
                "khal",
                format_tui("ikhal", apps.terminal),
                opacity=1,
                x=0.7,
                y=0.0,
                width=0.3,
                height=1,
            ),
            DropDown(
                "music",
                format_tui(apps.music_player, apps.terminal),
                opacity=0.8,
                x=0.0,
                y=0.0,
                width=1,
                height=1,
            ),
            DropDown(
                "files",
                format_tui(apps.file_manager, apps.terminal),
                # opacity=0.9,
                x=0.15,
                y=0.15,
                width=0.7,
                height=0.7,
            ),
            DropDown(
                "terminal",
                apps.terminal,
                x=0.25,
                y=0.15,
                width=0.5,
                height=0.7,
            ),
        ],
    ),
]

# Floating
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
    ]
)
