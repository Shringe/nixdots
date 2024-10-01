from libqtile.widget import base
from psutil import net_io_counters


class NetDisplay(base.InLoopPollText):
    def __init__(self, format="d:{} / u:{}", **config):
        super().__init__(**config)

        self.updateInterval: int = config["update_interval"]
        self.lastNet: net_io_counters = net_io_counters()
        self.format: str = format

    def poll(self) -> str:
        download, upload = self.getNewBandwidth()

        return self.format.format(
            self.formatBytes(download),
            self.formatBytes(upload),
        )

    def getNewBandwidth(self) -> (int, int):
        """
        Gets average bandwidth per second since last call
        """
        new_net = net_io_counters()

        download: int = (
            new_net.bytes_recv - self.lastNet.bytes_recv
        ) / self.updateInterval
        upload: int = (
            new_net.bytes_sent - self.lastNet.bytes_sent
        ) / self.updateInterval

        self.lastNet = new_net
        return download, upload

    @staticmethod
    def formatBytes(value: int, units=("", "k", "m", "Gi")) -> str:
        """
        Converts bytes to largest unit available, removes trailing zeros
        """
        final_unit: int
        final_value = float(value)
        for unit in range(len(units)):
            if abs(final_value) < 1024.0 or unit == "Gi":
                final_unit = unit
                break
            final_value /= 1024.0

        if final_unit > 1:
            return f"{final_value:.1f}".rstrip("0").rstrip(".") + units[final_unit]
        else:
            return f"{final_value:.0f}".rstrip("0").rstrip(".") + units[final_unit]
