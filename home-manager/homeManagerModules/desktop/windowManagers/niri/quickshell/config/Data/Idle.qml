pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    property bool inhibiting: false

    function toggleInhibit() {
        if (inhibiting) {
            console.debug("Disabling idle inhibitor");
            inhibiting = false;
        } else {
            console.debug("Enabling idle inhibitor");
            inhibiting = true;
        }
    }

    Process {
        running: inhibiting
        command: ["systemd-inhibit", "--what=idle", "--who=quickshell", "sleep", "infinity"]
    }
}
