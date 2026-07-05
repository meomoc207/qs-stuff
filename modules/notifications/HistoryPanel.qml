import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "root:/"

PanelWindow {
    id: panel
    required property var modelData
    screen: modelData

    property bool wantOpen: NotificationService.panelScreen === modelData
    property bool reallyVisible: wantOpen
    visible: reallyVisible

    onWantOpenChanged: {
        if (wantOpen) reallyVisible = true
        else closeTimer.start()
    }

    Timer {
        id: closeTimer
        interval: 200
        onTriggered: panel.reallyVisible = false
    }

    anchors { top: true; bottom: true; left: true; right: true }
    exclusiveZone: 0
    color: "transparent"

    WlrLayershell.namespace: "quickshell:notification-history"
    WlrLayershell.layer: WlrLayer.Overlay

    MouseArea {
        anchors.fill: parent
        onClicked: NotificationService.panelScreen = null
    }

    Rectangle {
        id: content
        anchors { top: parent.top; left: parent.left; topMargin: 0; leftMargin: 0 }
        width: 420
        height: panel.wantOpen ? 520 : 0
        clip: true
        color: Theme.night
        opacity: panel.wantOpen ? 1 : 0

        Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 160 } }

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "Notifications"
                    color: Theme.mist
                    font { family: Theme.fontFamily; bold: true; pixelSize: Theme.fontSizeLarge }
                    Layout.fillWidth: true
                }
                Text {
                    text: "Clear"
                    color: Theme.ember
                    font.family: Theme.fontFamily
                    MouseArea {
                        anchors.fill: parent
                        onClicked: NotificationService.history = []
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.umber }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 6
                model: NotificationService.history

                delegate: Rectangle {
                    required property var modelData
                    width: ListView.view.width
                    implicitHeight: entryContent.implicitHeight + 20
                    radius: 10
                    color: Theme.ash

                    RetainableLock {
                        object: modelData
                        locked: true
                    }

                    ColumnLayout {
                        id: entryContent
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 4

                        Text {
                            text: modelData.appName + ": " + modelData.summary
                            color: Theme.mist
                            font { family: Theme.fontFamily; bold: true; pixelSize: Theme.fontSizeLarge }
                            Layout.fillWidth: true
                            wrapMode: Text.Wrap
                        }
                        Text {
                            text: modelData.body
                            color: Theme.bark
                            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
                            Layout.fillWidth: true
                            wrapMode: Text.Wrap
                            visible: modelData.body.length > 0
                        }
                    }
                }
            }
        }
    }
}
