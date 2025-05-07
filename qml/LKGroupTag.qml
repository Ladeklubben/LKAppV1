import QtQuick 2.13

MouseArea {
    property color gcolor: lkpalette.g_flat;

    property Component content;

    Rectangle{
        id: colorstyler;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.bottom: parent.bottom;
        anchors.margins: 5;
        radius: 10;
        color: gcolor;
        width: 5;
    }

    Loader{
        anchors.left: colorstyler.right;
        anchors.right: parent.right;
        anchors.top: parent.top
        anchors.bottom: parent.bottom;
        anchors.margins: 5;
        sourceComponent: content;
    }

}
