// Shares common state for the active quickshell session
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Niri

import qs.inner.Data as Dat
import qs

Singleton {
    property ShellScreen currentScreen: Quickshell.screens[Quickshell.screens.length - 1]
    property Niri niri: _niri

    // The framerate to update animClock
    property int animFps: fancyAnimations ? 60 : 15
    property int animInterval: 1000 / animFps
    property real animClock: _animClock
    // Whether or not to prioritize fidelity over resources
    property bool fancyAnimations: !(gamemode || Dat.Hardware.battery.low)
    property bool gamemode: false

    Niri {
        id: _niri
        Component.onCompleted: connect()

        onConnected: console.debug("Connected to niri")
        onErrorOccurred: function (error) {
            console.error("Niri error:", error);
        }
    }

    Instantiator {
        model: _niri.workspaces
        delegate: Item {
            required property bool isFocused
            required property string output

            onIsFocusedChanged: {
                if (isFocused) {
                    const screen = Quickshell.screens.find(s => s.name === output);
                    if (screen && screen !== currentScreen) {
                        currentScreen = screen;
                    }
                }
            }
        }
    }

    Component.onCompleted: console.info("=".repeat(50) + " Reloading Quickshell " + "=".repeat(50))

    Timer {
        id: animTimer
        interval: animInterval
        running: true
        repeat: true

        onTriggered: {
            if (_animClock < 1.0) {
                animClock = _animClock;
            }
        }
    }

    property real _animClock: 0.0
    NumberAnimation on _animClock {
        from: -1.0
        to: 2.0
        duration: 5000
        loops: Animation.Infinite
        running: true
    }

    Process {
        id: gamemodeProcess
        command: [Config.dependencies.gamemoded, "-s"]

        stdout: StdioCollector {
            onStreamFinished: {
                if (gamemode && this.text === "gamemode is inactive\n") {
                    console.debug("Gamemode disabled");
                    gamemode = false;
                } else if (!gamemode && this.text === "gamemode is active\n") {
                    console.debug("Gamemode enabled");
                    gamemode = true;
                }
            }
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: gamemodeProcess.running = true
    }
}
