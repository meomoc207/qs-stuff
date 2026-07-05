import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "root:/"

PanelWindow {
    id: popupWindow
    required property var modelData
    screen: modelData

    property var hyprMonitor: Hyprland.monitorFor(modelData)
    visible: hyprMonitor?.focused ?? false

    anchors { top: true; left: true }
    exclusiveZone: 0
    color: "transparent"
    implicitWidth: 480
    implicitHeight: column.implicitHeight

    WlrLayershell.namespace: "quickshell:notifications"
    WlrLayershell.layer: WlrLayer.Overlay

    ColumnLayout {
        id: column
        anchors { top: parent.top; left: parent.left; margins: 10 }
        width: 460
        spacing: 10

        Repeater {
            model: NotificationService.popups

            Rectangle {
                id: card
                required property var modelData
                Layout.fillWidth: true
                implicitHeight: content.implicitHeight + 28
                radius: 12
                color: Theme.ash

                property int effectiveTimeout: {
                    if (modelData.expireTimeout > 0) return modelData.expireTimeout
                    if (modelData.urgency === 2) return 0
                    return 5000
                }

                Timer {
                    running: card.effectiveTimeout > 0
                    interval: card.effectiveTimeout
                    onTriggered: card.modelData.expire()
                }

                ColumnLayout {
                    id: content
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 8

                    Text {
                        text: card.modelData.summary
                        color: Theme.mist
                        font { family: Theme.fontFamily; bold: true; pixelSize: Theme.fontSizeLarge }
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                    }
                    Text {
                        text: card.modelData.body
                        color: Theme.bark
                        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                        visible: card.modelData.body.length > 0
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: card.modelData.dismiss()
                }
            }
        }
    }
}
