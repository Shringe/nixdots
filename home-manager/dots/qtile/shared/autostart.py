import psutil
from subprocess import Popen
from typing import List
from libqtile import hook
from libqtile.log_utils import logger


def get_pid(process_name: str) -> int | None:
    """
    Returns pid from process_name, retuns None if not exists.
    """

    for process in psutil.process_iter(["pid", "name"]):
        if process.info["name"] == process_name:
            return process.info["pid"]
    return None


def launch(command: str) -> None:
    """
    Runs application or command under qtile.
    """

    Popen(command, shell=True)


def launch_if_not_running(command: str) -> None:
    """
    Launches process if not already running.
    """

    program = command.split(" ")[0]
    pid = get_pid(program)

    if not pid:
        launch(command)


def relaunch(command: str) -> None:
    """
    Kills process if found before launching.
    """

    program = command.split(" ")[0]

    pid = get_pid(program)

    if pid:
        psutil.Process(pid).terminate()

    launch(command)


def register(launch_once: List[str], launch_again: List[str], restart: List[str]):
    """
    Subscribes to startup_once and statup qtile hooks and autostarts given lists respectively.
    """

    @hook.subscribe.startup_once
    def on_first_start():
        logger.info("Launching on_first_start()")
        for command in launch_once:
            launch(command)

    @hook.subscribe.startup
    def on_start():
        logger.info("Launching on_start()")
        for command in launch_again:
            launch_if_not_running(command)

        for command in restart:
            relaunch(command)
