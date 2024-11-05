from pathlib import Path
from typing import Optional, List


class Terminal:
    def __init__(
        self,
        exec: str,
        config_directory: Path,
        default_config_file: str,
        fmt_working_directory: str = "--working-directory={}",
        fmt_title: str = "-T {}",
        fmt_config_file: str = "--config-file={}",
        fmt_command: str = "-e {}",
        default_working_directory: Path = Path.home(),
    ) -> None:
        self.exec: str = exec
        self.config_file_name: str = default_config_file
        self.config_directory: Path = config_directory
        self.default_working_directory: Path = default_working_directory
        self.current_working_directory: Path = default_working_directory
        self.fmt_working_directory: str = fmt_working_directory
        self.fmt_title: str = fmt_title
        self.fmt_command: str = fmt_command
        self.fmt_config_file: str = fmt_config_file

    def new_instance(
        self,
        command: Optional[str] = None,
        working_diretory: Optional[str] = None,
        title: Optional[str] = None,
        config_file_name: Optional[str] = None,
    ) -> str:
        """Returns the cmd for opening a new window"""
        fmt: List[str] = [self.exec]
        if config_file_name:
            fmt.append(
                self.fmt_config_file.format(self.config_directory / config_file_name)
            )
        if working_diretory:
            fmt.append(self.fmt_working_directory.format(working_diretory))
        if title:
            fmt.append(self.fmt_title.format(title))
        if command:
            fmt.append(self.fmt_command.format(command))

        return " ".join(fmt)

    def new_tui_app(self, tui_cmd: str):
        raise NotImplementedError("Supposed to replace shared.format.format_tui()")
