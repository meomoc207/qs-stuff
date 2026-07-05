import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "root:/"

RowLayout {
    id: root
    required property var screen
    property var monitor: Hyprland.monitorFor(screen)
    spacing: 16

    Repeater {
        model: Hyprland.workspaces.values.filter(w => w.monitor === root.monitor)

        ColumnLayout {
            required property var modelData
            spacing: 2

            Text {
                id: label
                text: modelData.id
                color: modelData.active ? Theme.ember : Theme.rose
                font { family: Theme.fontFamily; pixelSize: Theme.fontSize; bold: true }
                Layout.alignment: Qt.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: modelData.activate()
                }
            }

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: label.implicitWidth
                height: 2
                radius: 1
                color: Theme.ember
                visible: modelData.active
            }
        }
    }
}
