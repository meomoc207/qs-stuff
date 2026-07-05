import Quickshell.Io
import QtQuick
import "root:/"

Text {
    id: root
    property int usage: 0

    text: "Mem: " + usage + "%"
    color: Theme.coral
    font { family: Theme.fontFamily; pixelSize: Theme.fontSize; bold: true }

    Process {
        id: proc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                const parts = data.trim().split(/\s+/)
                const total = parseInt(parts[1]) || 1
                const used = parseInt(parts[2]) || 0
                root.usage = Math.round(100 * used / total)
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: proc.running = true
    }
}
