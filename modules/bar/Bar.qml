import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "root:/"

PanelWindow {
    id: bar
    required property var modelData
    screen: modelData

    anchors { top: true; left: true; right: true }
    implicitHeight: 35
    color: Theme.night

    WlrLayershell.namespace: "quickshell:bar"
    WlrLayershell.layer: WlrLayer.Top

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
	
	Bell { screen: bar.modelData }
	Rectangle { width: 1; height: 16; color: Theme.mist }
        Workspaces { screen: bar.modelData }

        Item { Layout.fillWidth: true }
	Network {}
	Rectangle { width: 1; height: 16; color: Theme.mist }
        Cpu {}
        Rectangle { width: 1; height: 16; color: Theme.mist }
        Memory {}
        Rectangle { width: 1; height: 16; color: Theme.mist }
	Battery {}
	Rectangle { width: 1; height: 16; color: Theme.mist }
	Audio {}
        Rectangle { width: 1; height: 16; color: Theme.mist }
	Clock {}
	Rectangle { width: 1; height: 16; color: Theme.mist }
	Tray { trayWindow: bar}
    }
}
