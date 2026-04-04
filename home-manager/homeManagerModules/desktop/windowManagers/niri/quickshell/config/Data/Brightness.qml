pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io

import qs

Singleton {
    id: root

    property bool auto: false

    Process {
        id: wluma
        command: [Config.dependencies.wluma]
        running: root.auto
        onRunningChanged: console.debug("Wluma running:", running)
    }

    function brightnessctl(args) {
        const cmd = [Config.dependencies.brightnessctl, ...args];
        Quickshell.execDetached(cmd);
        console.debug(cmd);
    }

    function increaseBrightness() {
        brightnessctl(["set", "5%+"]);
    }

    function decreaseBrightness() {
        brightnessctl(["set", "5%-"]);
    }
}
