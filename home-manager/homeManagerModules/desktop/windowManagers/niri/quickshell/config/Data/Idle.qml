pragma Singleton

import Quickshell
import Quickshell.Io

import qs

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
        command: [Config.dependencies.systemdInhibit, "--what=idle", "--who=quickshell", "sleep", "infinity"]
    }
}
