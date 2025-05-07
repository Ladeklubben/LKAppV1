import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Rectangle{
    property alias icon: menuicon.text
    property alias text: menutxt.text;
    property alias description: desctxt.text;
    property color icon_bk_color: lkpalette.signalgreen;
    property color icon_color: lkpalette.base_white;
    property alias value: valueText.text;
    property alias unit: unitText.text; 
    color: lkpalette.base_extra_dark;
    radius: 20;
    height: 85;

    Row{
        id: row;
        anchors {
            left: parent.left;
            top: parent.top;
            bottom: parent.bottom;
        }
        padding: 20;
        spacing: 20;
        Rectangle {
            color: icon_bk_color;
            height: row.height - 2 * row.padding;
            width: row.height - 2 * row.padding;
            radius: 10;
        
            LKIcon{
                id: menuicon;
                font.pointSize: 16;
                color: icon_color;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.horizontalCenter: parent.horizontalCenter;
            }
        }

        ColumnLayout{
            Label{
                id: menutxt;
                Layout.topMargin: -4;
                color: lkpalette.base_white;
                font.pointSize: lkfont.sizeNormal;
                font.bold: true;
            }
            Label{
                Layout.leftMargin: 0;
                Layout.topMargin: -2;
                id: desctxt;
                color: lkpalette.menuItemDescription;
                text: "Description";
                font.pointSize: 12;
            }
        }
    }
    Row {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            margins: 20
        }
        spacing: 8

        Label {
            id: valueText
            text: "Value" // Replace with your value
            color: lkpalette.base_white
            font {
                pointSize: lkfont.sizeNormal;
                bold: true
            }
        }

        Label {
            id: unitText
            text: "Unit" // Replace with your unit
            color: lkpalette.base_white
            font.pointSize: 12
            anchors.bottom: parent.bottom
        }
    }
}
