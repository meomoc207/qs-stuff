import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "root:/"

RowLayout {
    id: root
    required property var screen
    property var monitor: Hyprland.monitorFor(screen)
    spacing: 6

    Repeater {
        model: Hyprland.workspaces.values.filter(w => w.monitor === root.monitor)

        Text {
            required property var modelData
            text: modelData.id
            color: modelData.active ? Theme.ember : Theme.rose
            font { family: Theme.fontFamily; pixelSize: Theme.fontSize; bold: true }

            MouseArea {
                anchors.fill: parent
                onClicked: modelData.activate()
            }
        }
    }
}
