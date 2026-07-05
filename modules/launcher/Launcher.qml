import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "root:/"

PanelWindow {
    id: launcher
    required property var modelData
    screen: modelData

    property var hyprMonitor: Hyprland.monitorFor(modelData)
    property bool wantOpen: LauncherState.open && (hyprMonitor?.focused ?? false)
    property bool reallyVisible: wantOpen
    visible: reallyVisible

    onWantOpenChanged: {
        if (wantOpen) {
            reallyVisible = true
            searchInput.text = ""
            searchInput.forceActiveFocus()
        } else {
            closeTimer.start()
        }
    }

    Timer {
        id: closeTimer
        interval: 180
        onTriggered: launcher.reallyVisible = false
    }

    anchors { top: true; left: true; right: true; bottom: true }
    exclusiveZone: 0
    color: "transparent"

    WlrLayershell.namespace: "quickshell:launcher"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    MouseArea {
        anchors.fill: parent
        onClicked: LauncherState.close()
    }

    function fuzzyScore(query, target) {
        if (query.length === 0) return 1
        const q = query.toLowerCase()
        const t = target.toLowerCase()
        let qi = 0
        let score = 0
        let lastMatch = -1
        for (let ti = 0; ti < t.length && qi < q.length; ti++) {
            if (t[ti] === q[qi]) {
                score += (lastMatch === ti - 1) ? 3 : 1
                lastMatch = ti
                qi++
            }
        }
        return (qi === q.length) ? score : -1
    }

    function filterApps(query) {
        const apps = DesktopEntries.applications.values
        const scored = []
        for (const entry of apps) {
            const s = fuzzyScore(query, entry.name)
            if (s >= 0) scored.push({ entry: entry, score: s })
        }
        scored.sort((a, b) => b.score - a.score)
        return scored.slice(0, 50)
    }

    Rectangle {
        id: box
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; topMargin: 0 }
        width: 560
        property int fullHeight: Math.min(480, 90 + resultsList.contentHeight)
        height: launcher.wantOpen ? fullHeight : 0
        clip: true
        radius: 0
        color: Theme.night
        opacity: launcher.wantOpen ? 1 : 0

        Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 160 } }

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

            TextInput {
                id: searchInput
                Layout.fillWidth: true
                color: Theme.mist
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
                focus: true

                Keys.onEscapePressed: LauncherState.close()
                Keys.onDownPressed: resultsList.currentIndex = Math.min(resultsList.currentIndex + 1, resultsList.count - 1)
                Keys.onUpPressed: resultsList.currentIndex = Math.max(resultsList.currentIndex - 1, 0)
                Keys.onReturnPressed: {
                    const item = resultsList.model[resultsList.currentIndex]
                    if (item) {
                        item.entry.execute()
                        LauncherState.close()
                    }
                }

                onTextChanged: resultsList.currentIndex = 0
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.umber }

            ListView {
                id: resultsList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: launcher.filterApps(searchInput.text)
                highlightMoveDuration: 80

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: ListView.view.width
                    height: 44
                    radius: 0
                    color: index === resultsList.currentIndex ? Theme.umber : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 10

                        IconImage {
                            implicitSize: 28
                            source: Quickshell.iconPath(modelData.entry.icon, true)
                        }
                        Text {
                            text: modelData.entry.name
                            color: Theme.mist
                            font { family: Theme.fontFamily; pixelSize: Theme.fontSize }
                            Layout.fillWidth: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            modelData.entry.execute()
                            LauncherState.close()
                        }
                    }
                }
            }
        }
    }
}
