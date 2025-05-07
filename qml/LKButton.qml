import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: button
    property color color: lkpalette.button;;
    property color bordercolor: "white";
    property color textcoler: lkpalette.buttonText;

    property color colorDisabled: lkpalette.buttonDisabled;
    property color textcolorDisabled: lkpalette.buttonTextDisabled;

    property alias icon_txt: button_icon.text;
    property alias icon_size: button_icon.font.pointSize;
    property alias icon_color: button_icon.color;

    property int pointsize: 18;
    property bool bold: false;
    property int button_radius: 3;
    flat: true
    background: Rectangle {
        color: button.down ? lkpalette.buttonDown : enabled ? button.color : button.colorDisabled;
        border.color: button.bordercolor;
        border.width: 2;
        radius: button_radius;

        Label{
            id: button_icon;
            anchors.left: parent.left;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.margins: 15;
            color: "white";
            font.family: lkfonts.name;
        }
    }
    contentItem: Label{
        color: enabled ? textcoler : textcolorDisabled;
        text: button.text;
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter;
        font.pointSize: pointsize;
        font.bold: bold;
    }
}
