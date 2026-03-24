// Shares common state for the active quickshell session
pragma Singleton

import QtQuick
import Quickshell
import Niri

Singleton {
    property ShellScreen currentScreen: Quickshell.screens[Quickshell.screens.length - 1]
    property Niri niri: _niri

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
}
