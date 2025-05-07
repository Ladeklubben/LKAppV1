import QtQuick 2.13
import QtQuick.Controls
import QtQuick.Controls.Basic

ScrollBar{
    contentItem: Rectangle {
        implicitWidth: 6
        radius: width/2
        color: lkpalette.border
    }

    background: Rectangle {
        implicitWidth: 6
        color: lkpalette.base
    }

    visible: parent.height < parent.contentHeight
}
