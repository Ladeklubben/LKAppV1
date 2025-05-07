import QtQuick 2.15
import QtQuick.Controls 2.15

CheckBox {
    id: control
    property int size: 30 // Adjust this value to change the overall size

    indicator: Rectangle {
        implicitWidth: control.size
        implicitHeight: control.size
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: control.size / 4 // This makes it rounded
        border.color: control.checked ? lkpalette.signalgreen : lkpalette.base_white
        border.width: 2

        Rectangle {
            width: control.size * 0.6
            height: control.size * 0.6
            radius: width / 4
            color: lkpalette.signalgreen
            visible: control.checked
            anchors.centerIn: parent
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: lkpalette.signalgreen
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
