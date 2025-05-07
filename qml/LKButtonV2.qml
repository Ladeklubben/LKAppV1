import QtQuick.Layouts 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15


Rectangle{
    radius: 5;
    property color button_color: lkpalette.signalgreen;
    color: enabled ? button_color : lkpalette.base_grey;
    signal clicked();

    property alias text: buttxt.text;
    property alias bold: buttxt.font.bold;
    property alias fontsize: buttxt.font.pointSize;

    height: 75;

    MouseArea{
        anchors.fill: parent;
        onClicked: parent.clicked();
    }
    Label{
        id: buttxt;
        anchors.centerIn: parent;
        color: lkpalette.base_white;
        font.pointSize: 30;
    }
}
