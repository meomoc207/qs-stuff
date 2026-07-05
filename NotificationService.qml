pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

QtObject {
    id: root
    property var popups: []
    property var history: []
    property var panelScreen: null

    function togglePanel(screen) {
        panelScreen = (panelScreen === screen) ? null : screen
    }

    property NotificationServer server: NotificationServer {
        keepOnReload: false
        actionsSupported: true
        imageSupported: true
        bodyMarkupSupported: true

        onNotification: notification => {
            notification.tracked = true
            root.popups = [...root.popups, notification]
            root.history = [notification, ...root.history]

            notification.closed.connect(() => {
                root.popups = root.popups.filter(n => n !== notification)
            })
        }
    }
}
