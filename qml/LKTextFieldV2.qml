import QtQuick.Layouts 1.12
import QtQuick 2.15
import QtQuick.Controls 2.12

Item {
    property alias text: txtinp.text;
    property alias headline: hline.text;
    property alias fontsize: txtinp.font.pointSize;

    Label{
        id: hline;
        text: "Headline"

        anchors.top: parent.top;
        anchors.left: parent.left;
        color: lkpalette.base;
    }

    Rectangle{
        anchors.bottom: parent.bottom;
        anchors.left: parent.left
        anchors.right: parent.right;
        anchors.top: hline.bottom;
        anchors.topMargin: 3;
        color: lkpalette.base_light;

        TextInput{
            id: txtinp;
            text: "Sample text";
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            anchors.leftMargin: 10;
            verticalAlignment: Qt.AlignVCenter;
            font.pointSize: 14;
            color: lkpalette.base;
        }
    }
}
