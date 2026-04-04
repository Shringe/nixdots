pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io

import qs

Singleton {
    readonly property list<string> extra_args: []

    function swww(args) {
        const cmd = [Config.dependencies.swww, ...args];
        Quickshell.execDetached(cmd);
        console.debug(cmd);
    }

    function img(wallpaper: string, output: string) {
        console.info("Setting wallpaper:", wallpaper);
        const args = ["img", wallpaper, "--outputs", output, ...extra_args];
        swww(args);
    }
}
