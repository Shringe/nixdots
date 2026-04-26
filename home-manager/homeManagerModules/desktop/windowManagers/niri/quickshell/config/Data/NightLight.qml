pragma Singleton

import Quickshell
import Quickshell.Io

import qs

Singleton {
    property alias process: process

    function toggle() {
        process.running = !process.running;
    }

    Process {
        id: process
        running: false
        command: [Config.dependencies.gammastep, "-O", "4000"]
    }
}
