import Quickshell.Networking
import Quickshell
import QtQuick
import "root:/"

Text {
    id: root
    property var devices: Networking.devices.values
    property var wiredDevice: devices.find(d => d.type === 2 && d.connected)
    property var wifiDevice: devices.find(d => d.type === 1 && d.connected)

    Component.onCompleted: {
        const wifi = devices.find(d => d.type === 1)
        if (wifi && !wifi.scannerEnabled) wifi.scannerEnabled = true
    }

    property var activeWifiNetwork: {
        if (!wifiDevice) return null
        const nets = wifiDevice.networks?.values ?? []
        return nets.find(n => n.connected) ?? null
    }

    text: "Net: " + (
        wiredDevice ? "Wired" :
        wifiDevice ? (activeWifiNetwork ? activeWifiNetwork.name : "Connected") :
        "Disconnected"
    )
    color: Theme.blush
    font { family: Theme.fontFamily; pixelSize: Theme.fontSize; bold: true }

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["kitty", "-e", "nmtui"])
    }
}
