from os.path import expanduser, join, basename
from shared.themes.Theme import Theme, deconstruct_path
from typing import Any
from dataclasses import is_dataclass
from importlib import import_module


def format_tui(
    command: str,
    terminal: str,
    title="",
) -> str:
    """
    Formats TUI applications according to internal options that should be set within this function.
    """
    match terminal:
        case "alacritty":
            theme: str = expanduser("~/.config/alacritty/tui.toml")
            fmt: str = "{} --config-file=" + theme + " -T {} -e {}"
        case "nixGL alacritty":
            theme: str = expanduser("~/.config/alacritty/tui.toml")
            fmt: str = "{} --config-file=" + theme + " -T {} -e {}"
        case _:
            raise NotImplementedError(
                f'Must add "{terminal}" to the list of supported terminals'
            )

    if not title:
        title = command

    return fmt.format(terminal, title, command)


def get_theme(name: str, theme_dir="shared.themes") -> Theme:
    module: str = f"{theme_dir}.{name}"
    if module.endswith(".py"):
        module = module[:-3]

    return import_module(module).theme


def serialize_dataclass(obj: Any, indent=4, _starting_indent=0) -> str:
    """
    Recursively serializes a dataclass instance into a Python code representation.
    """

    if not is_dataclass(obj):
        return repr(obj)

    lines: list = []
    current_indent: int = _starting_indent + indent
    pad: str = " " * current_indent

    # Recursively serializing file
    for field in obj.__dataclass_fields__:
        value = getattr(obj, field)

        if isinstance(value, str):
            value = deconstruct_path(value)

        lines.append(
            f"{field}={serialize_dataclass(value, indent=indent, _starting_indent=current_indent)},"
        )

    # Concatenating file
    serialized_obj: str = (
        f"{obj.__class__.__name__}(\n{pad}"
        + f"\n{pad}".join(lines)
        + f"\n{' ' * _starting_indent})"
    )

    # Removing double qutoes around function calls, changing single qutoes to double
    # Only on last/parent dataclass
    if _starting_indent == 0:
        return serialized_obj.replace('"', "").replace("'", '"')

    return serialized_obj


def format_theme_file(theme: Theme) -> str:
    """
    Serializes theme to theme.py in proper format.
    """

    file_lines: list = [
        "# Auto-generated theme configuration",
        "from shared.themes.Theme import Theme, ThemeColors, ThemeIcons",
        "from os.path import expanduser",
        "",
        "theme = " + serialize_dataclass(theme),
    ]

    return "\n".join(file_lines)
