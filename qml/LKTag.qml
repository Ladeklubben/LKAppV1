import QtQuick 2.0
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Rectangle{
    color: "transparent"
    radius: 3;
    border.width: 2;
    border.color: "white"

    property alias tagname: name.text;
    property alias value:  valfield.text;
    property alias unit: unitfield.text;

    ColumnLayout{
        spacing: 5;
        anchors.fill: parent;
        anchors.margins: 5;

        Label{
            id: name;
            color: "White";
            font.pointSize: 26;
        }
        RowLayout{
            Layout.alignment: Qt.AlignRight
            Label{
                id: valfield;
                color: "White";
                font.pointSize: 18;
                Layout.alignment: Qt.AlignRight
                verticalAlignment: Text.AlignVCenter
            }
            Label{
                id: unitfield;
                color: "White";
                font.pointSize: 18;
                Layout.alignment: Qt.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

}
