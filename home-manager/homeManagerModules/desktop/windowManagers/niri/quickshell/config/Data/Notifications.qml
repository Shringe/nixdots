pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: notif

    property bool dndEnabled: false
    property int notifCount: notifServer.trackedNotifications.values.length
    property NotificationServer server: notifServer
    property var latestNotification: null
    signal notificationReceived(var notification)

    function clearNotifs() {
        [...notifServer.trackedNotifications.values].forEach(elem => {
            elem.dismiss();
        });
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

        onNotification: n => {
            n.tracked = true;
            notif.latestNotification = n;
            notif.notificationReceived(n);
        }
    }
}
