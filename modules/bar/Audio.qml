import Quickshell.Services.Pipewire
import QtQuick
import "root:/"

Text {
    id: root
    property var sink: Pipewire.defaultAudioSink
    property real volume: sink?.audio?.volume ?? 0
    property bool muted: sink?.audio?.muted ?? false

    text: "Vol: " + (muted ? "mute" : Math.round(volume * 100) + "%")
    color: Theme.blush
    font { family: Theme.fontFamily; pixelSize: Theme.fontSize; bold: true }

    PwObjectTracker { objects: [root.sink] }

    MouseArea {
        anchors.fill: parent
        onClicked: if (root.sink?.audio) root.sink.audio.muted = !root.sink.audio.muted
        onWheel: wheel => {
            if (!root.sink?.audio) return
            const step = 0.05
            const delta = wheel.angleDelta.y > 0 ? step : -step
            root.sink.audio.volume = Math.max(0, Math.min(1, root.sink.audio.volume + delta))
        }
    }
}
