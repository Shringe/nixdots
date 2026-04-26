pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: notif

    property bool dndEnabled: false
    property int notifCount: notifServer.trackedNotifications.values.length
    property NotificationServer server: notifServer
    property Notification latestNotification: null
    signal notificationReceived(Notification notification)

    function clearNotifs() {
        [...notifServer.trackedNotifications.values].forEach(elem => {
            elem.dismiss();
        });
    }

    function shouldIgnore(n: Notification): bool {
        return n.appName === "KDE Connect" && n.summary === "Home Assistant" && n.body === "Updating sensors";
    }

    function addNotif(n: Notification): void {
        if (shouldIgnore(n)) {
            console.debug("Ignoring notification:", n.summary);
            n.dismiss();
            return;
        }

        // console.debug(n.appName);
        // console.debug(n.summary);
        // console.debug(n.body);

        n.tracked = true;
        notif.latestNotification = n;
        notif.notificationReceived(n);
    }

    NotificationServer {
        id: notifServer

        actionIconsSupported: true
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: n => addNotif(n)
    }
}
