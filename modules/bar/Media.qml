import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import "root:/"

Item {
    id: root
    property var player: {
        const list = Mpris.players.values
        return list.find(p => p.isPlaying) ?? list[0] ?? null
    }
    visible: player !== null
    Layout.preferredWidth: 240
    Layout.maximumWidth: 240
    implicitHeight: label.implicitHeight
    clip: true

    property string fullText: player ? ((player.trackArtist ? player.trackArtist + " - " : "") + (player.trackTitle || "Unknown")) : ""
    property bool overflow: label.implicitWidth > root.width

    Text {
        id: label
        text: root.fullText
        color: Theme.rose
        font { family: Theme.fontFamily; pixelSize: Theme.fontSize }
        x: 0

        SequentialAnimation on x {
            running: root.overflow
            loops: Animation.Infinite
            PauseAnimation { duration: 1200 }
            NumberAnimation {
                from: 0
                to: -(label.implicitWidth - root.width)
                duration: Math.max(2000, (label.implicitWidth - root.width) * 30)
                easing.type: Easing.Linear
            }
            PauseAnimation { duration: 1200 }
            NumberAnimation {
                from: -(label.implicitWidth - root.width)
                to: 0
                duration: Math.max(2000, (label.implicitWidth - root.width) * 30)
                easing.type: Easing.Linear
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: mouse => {
            if (!root.player) return
            if (mouse.button === Qt.LeftButton) {
                root.player.isPlaying = !root.player.isPlaying
            } else if (mouse.button === Qt.RightButton && root.player.canGoNext) {
                root.player.next()
            } else if (mouse.button === Qt.MiddleButton && root.player.canGoPrevious) {
                root.player.previous()
            }
        }
    }
}
