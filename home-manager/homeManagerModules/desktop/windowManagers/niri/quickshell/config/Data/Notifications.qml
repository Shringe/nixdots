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

    function addNotif(n) {
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
