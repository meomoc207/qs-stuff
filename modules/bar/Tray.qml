// modules/bar/Tray.qml
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    required property var trayWindow
    spacing: 8

    Repeater {
        model: SystemTray.items

        IconImage {
            id: icon
            required property var modelData
            implicitSize: 16
            source: modelData.icon

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        icon.modelData.activate()
                    } else if (mouse.button === Qt.MiddleButton) {
                        icon.modelData.secondaryActivate()
                    } else if (mouse.button === Qt.RightButton && icon.modelData.hasMenu) {
                        const pos = mapToItem(null, mouse.x, mouse.y)
                        icon.modelData.display(root.trayWindow, pos.x, pos.y)
                    }
                }
                onWheel: wheel => icon.modelData.scroll(wheel.angleDelta.y, false)
            }
        }
    }
}
