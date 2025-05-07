import QtQuick
import QtQuick.Layouts 1.12

Rectangle{
    id: shelf
    anchors.bottom: parent.bottom;
    anchors.bottomMargin: -25
    width: parent.width;
    height: 200;
    color: lkpalette.base_extra_dark;
    radius: 25;

    signal firstButtonPressed()
    signal secondButtonPressed()

    property string firstButtonText: "First Button"
    property string secondButtonText: "Second Button"

    ColumnLayout{
        id: columnLayout
        anchors.fill: parent;
        spacing: 20;
        anchors.margins: 20
        anchors.topMargin: 30
        anchors.bottomMargin: 60
        

        LKButtonV3{
            id: firstButton;
            Layout.fillWidth: true;
            text: firstButtonText;
            onClicked: firstButtonPressed()
        }

        LKButtonV3{
            id: secondButton;
            Layout.fillWidth: true;
            text: secondButtonText;
            button_color: lkpalette.base_white;
            onClicked: secondButtonPressed()
        }
    }
}