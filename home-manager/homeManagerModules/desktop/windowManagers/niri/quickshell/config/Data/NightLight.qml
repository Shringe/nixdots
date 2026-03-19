pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    function toggle() {
        wlsunsetProcess.running = !wlsunsetProcess.running;
    }

    Process {
        id: wlsunsetProcess
        command: ["gammastep", "-O", "4000"]
    }
}
