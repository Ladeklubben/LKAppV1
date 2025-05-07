import QtQuick 2.0
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtLocation 5.14
import QtPositioning 5.14


MouseArea{
    anchors.fill: parent
    property Component buttons;
    property string message: "";
    signal ok();
    Rectangle{
        anchors.fill: parent;
        color: "Transparent"
        visible: true
    }

    Rectangle{
        width: 50;
        height: 50;
        radius: width/2;
        //x: frame.x+frame.width - width/2;
        y: frame.y - height/2;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.bottom: frame.top;
        anchors.bottomMargin: 25;
        color: frame.color;
        border.width: 1;
        border.color: "white";

        LKLabel{
            anchors.centerIn: parent;
            text: "X";
            font.bold: true;
            font.pointSize: lkfont.sizeLarge;
        }

        MouseArea{
            anchors.fill: parent

            onClicked: {
                ok();
                alertbox.source = "";
                alertbox.sourceComponent = undefined;
            }
        }
    }

    Rectangle {
        id: frame;
        width: parent.width * 0.9;
        height: parent.height * 0.4;
        anchors.centerIn: parent;

        color: lkpalette.base;
        border.color: lkpalette.border;
        border.width: 2;

        Flickable{
            id: flickable
            anchors.fill: parent
            contentHeight: text.contentHeight
            clip: true
            anchors.rightMargin: 2
            anchors.topMargin: 2
            anchors.bottomMargin: 2

            Text{
                id: text
                height: text.height
                anchors.fill: parent;
                width: frame.width - alertBar.width
                anchors.margins: 15;
                text: message
                color: lkpalette.text;
                font.pointSize: 15; // was 20
                wrapMode: Text.WordWrap;
            }
            ScrollBar.vertical: LKScrollBar{
                id: alertBar
            }

        }



        Loader{
            id: bottom_bar;
            sourceComponent: buttons;
            anchors.margins: 5;
            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
        }
    }
}
