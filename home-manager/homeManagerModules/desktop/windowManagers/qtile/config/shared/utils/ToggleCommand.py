from libqtile.log_utils import logger


class ToggleCommand:
    def __init__(self, on_command: str, off_command: str, initial_state=False) -> None:
        self.onCommand: str = on_command
        self.offCommand: str = off_command

        self.toggleState: bool = initial_state

    def toggle(self, qtile=None) -> str:
        command: str
        if self.toggleState:
            self.toggleState = False
            command = self.offCommand
        else:
            self.toggleState = True
            command = self.onCommand

        if qtile:
            logger.info(f'Toggled to {self.toggleState} || qtile.spawn("{command}")')
            qtile.spawn(command)

        return command
