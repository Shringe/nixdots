from libqtile import hook


@hook.subscribe.client_focus
def set_hint(window):
    window.window.set_property(
        "I3_FLOATING_WINDOW", str(window.floating), type="STRING", format=8
    )
