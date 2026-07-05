import QtQuick
import "root:/"

Text {
    id: root
    required property var screen
    text: "Live happily!"
    color: Theme.honey
    font { family: Theme.fontFamily; pixelSize: Theme.fontSize; bold: true }

    MouseArea {
        anchors.fill: parent
        onClicked: NotificationService.togglePanel(root.screen)
    }
}
