import Quickshell.Io
import QtQuick
import "root:/"

Text {
    id: root
    property int usage: 0
    property int lastIdle: 0
    property int lastTotal: 0

    text: "CPU: " + usage + "%"
    color: Theme.honey
    font { family: Theme.fontFamily; pixelSize: Theme.fontSize; bold: true }

    Process {
        id: proc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                const p = data.trim().split(/\s+/)
                const idle = parseInt(p[4]) + parseInt(p[5])
                const total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
                if (root.lastTotal > 0 && total !== root.lastTotal) {
                    root.usage = Math.round(100 * (1 - (idle - root.lastIdle) / (total - root.lastTotal)))
                }
                root.lastTotal = total
                root.lastIdle = idle
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
