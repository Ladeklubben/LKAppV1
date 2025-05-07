import QtQuick.Layouts 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15


Rectangle{
    radius: 20;
    property color button_color: lkpalette.signalgreen;
    color: enabled ? button_color : lkpalette.base_grey;
    signal clicked();

    property alias text: buttxt.text;
    property alias bold: buttxt.font.bold;
    property alias fontsize: buttxt.font.pointSize;
    property alias fontWeight: buttxt.font.weight;

    height: 50;

    MouseArea{
        anchors.fill: parent;
        onClicked: parent.clicked();
    }
    Label{
        id: buttxt;
        anchors.centerIn: parent;
        color: lkpalette.base;
        font.pointSize: 18;
        font.weight: Font.Bold;
        //font.capitalization: Font.AllUppercase; // Add this line
    }
}