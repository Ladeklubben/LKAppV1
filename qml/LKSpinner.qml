import QtQuick
import QtQuick.Controls

LKIcon {
    id: spin
    text: "\uE834"

    property bool running: false
    visible: running

    RotationAnimation {
        target: spin
        running: spin.running
        from: 0
        to: 360
        duration: 1000
        loops: Animation.Infinite
    }
}
