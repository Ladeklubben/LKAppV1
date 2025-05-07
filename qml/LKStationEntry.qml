import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Rectangle{
    id: gb;
    color: "transparent";
    border.width: 1;
    border.color: "black";
    property string stationid;
    property var stationobj;
    property string brief;

    signal clicked();
    signal pressAndHold();

    property bool markActive: false;
    property color textcolor: "white";
    Layout.fillWidth: true;
    //width: parent.width;
    Column{
        Label{
            id: entry;
            color: textcolor
            font.pointSize: lkfont.sizeLarge;
            font.italic: markActive;
            font.bold: markActive;
            //anchors.verticalCenter : parent.verticalCenter;
            text: stationid;
        }
        Label{
            color: textcolor
            font.pointSize: lkfont.sizeNormal;
            font.italic: markActive;
            font.bold: markActive;
            //anchors.verticalCenter : parent.verticalCenter;
            text: brief;
        }
    }
    MouseArea{
        id: ma;
        anchors.fill: parent;
        onClicked: gb.clicked();
        onPressAndHold: gb.pressAndHold();
    }
}
