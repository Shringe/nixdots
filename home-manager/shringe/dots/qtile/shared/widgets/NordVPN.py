from libqtile.widget import base
import subprocess
import re


class NordVPN(base.InLoopPollText):
    def __init__(
        self,
        disabled_icon_path: str,
        enabled_icon_path: str,
        icon_name="nordvpn_icon",
        **config,
    ):
        """
        requires widget.Image on the same bar with name="nordvpn_icon" parameter.
        """
        super().__init__(**config)
        self.iconName: str = icon_name
        self.disabledIconPath: str = disabled_icon_path
        self.enabledIconPath: str = enabled_icon_path

    def poll(self) -> str:
        """
        Displays output of self.getState() and
        adjusts widget.Image with name="nordvpn_icon" parameter to reflect output of self.getState().
        """
        vpn_state: str = self.getState()
        nordvpn_icon = self.qtile.widgets_map[self.iconName]

        if vpn_state == "Off":
            nordvpn_icon.update(self.disabledIconPath)
            # vpn_state = ""
        else:
            nordvpn_icon.update(self.enabledIconPath)

        return vpn_state

    # @lazy.function
    @staticmethod
    def disableNord(qtile) -> None:
        qtile.cmd_spawn("nordvpn disconnect")
        # subprocess.Popen(["nordvpn", "disconnect"])

    @staticmethod
    def getState() -> str:
        """
        Uses "nordvpn status" and regex to get the city of connection if connected
        """
        full_status: str = subprocess.check_output(["nordvpn", "status"]).decode(
            "utf-8"
        )

        if "Status: Connected" in full_status:
            return re.search("City: (.+)", full_status).group()[6:]  # city name
        else:
            return "Off"
