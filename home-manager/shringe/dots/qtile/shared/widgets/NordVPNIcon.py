from customWidgets.NordVPN import NordVPN
from libqtile import widget


class NordVPNIcon(widget.Image):
    def __init__(self, nordvpn_widget: NordVPN):
        self.nordvpnWidget: NordVPN = nordvpn_widget
