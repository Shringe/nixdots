from libqtile.log_utils import logger
from os import path
from json import load
from libqtile.config import Key
from libqtile.lazy import LazyCall
# from evdev import ecodes


class KeyboardLayout:
    def __init__(
        self,
        layout: str,
        conversion_layout="qwerty",
        keymaps_dir=path.join(path.dirname(__file__), "keymaps.json"),
    ) -> None:
        """
        Translates keys by physical location using simple keymaps.
        To add a new layout make a new keymap in keymaps.json,
        then pass your layout into the constructor.
        """
        with open(keymaps_dir, "r") as keymaps:
            self.keyMaps = load(keymaps)

        # maps selected conversion layout to selected keyboard layout
        self.layoutMapping: dict = self.mapLayout(conversion_layout, layout)

        self._layout: str = layout
        self.conversionLayout: str = conversion_layout

    @property
    def layout(self) -> str:
        return self._layout

    @layout.setter
    def layout(self, new_layout: str) -> None:
        """
        Sets self.layout and regenerates self.layoutMapping
        """
        if new_layout == self.layout:
            return
        logger.info(f"Changing keyboard layout from {self.layout} to {new_layout}")

        self.layoutMapping = self.mapLayout(self.conversionLayout, new_layout)
        self._layout = new_layout

    def mapLayout(self, conversion_layout: str, layout: str) -> dict:
        return dict(zip(self.keyMaps[conversion_layout], self.keyMaps[layout]))

    def translateKey(self, key: str) -> str:
        """
        Translates conversion layout key to layout key if possible
        """
        try:
            return self.layoutMapping[key]
        except KeyError:
            return key

    def Key(
        self,
        modifiers: list[str],
        key: str | int,
        *commands: LazyCall,
        desc: str = "",
        swallow: bool = True,
    ) -> Key:
        # bkey = key
        if isinstance(key, str):
            key = self.translateKey(key)
            # key = self.stringToKeycode(key)
        # logger.warning(f"{bkey=} || {key=}")

        bind: Key = Key(
            modifiers,
            key,
            *commands,
            desc=desc,
            swallow=swallow,
        )

        return bind

    @staticmethod
    def stringToKeycode(key: str) -> int | str:
        # Convert string to uppercase and prepend 'KEY_' to match evdev's naming convention
        if key in list(";'"):
            return key
        key_name: str = "KEY_" + key.upper()

        # Get the keycode from ecodes
        return getattr(ecodes, key_name, key)
