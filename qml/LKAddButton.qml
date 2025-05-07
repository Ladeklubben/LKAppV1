import QtQuick 2.0

MouseArea{
    id: addContainer;
    height: 100;

    property int crosssize: 50;
    /* Create the green + */
    Rectangle{
        width: parent.crosssize;
        height: 5;
        anchors.centerIn: parent;
        color: lkpalette.signalgreen;
    }
    Rectangle{
        width: 5;
        height: parent.crosssize;
        anchors.centerIn: parent;
        color: lkpalette.signalgreen;
    }
}
