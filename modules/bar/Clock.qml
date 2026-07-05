import QtQuick
import "root:/"

Text {
    id: root
    color: Theme.ember
    font { family: Theme.fontFamily; pixelSize: Theme.fontSize; bold: true }
    text: Qt.formatDateTime(new Date(), "ddd, dd MMM - HH:mm")

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.text = Qt.formatDateTime(new Date(), "ddd, dd MMM - HH:mm")
    }
}
