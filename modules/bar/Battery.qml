import Quickshell.Services.UPower
import QtQuick
import "root:/"

Text {
    property var device: UPower.displayDevice
    text: "Bat: " + (device ? Math.round(device.percentage * 100) : 0) + "%"
    color: Theme.sage
    font { family: Theme.fontFamily; pixelSize: Theme.fontSize; bold: true }
}
