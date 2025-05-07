import QtQuick 2.15

import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import QtQuick.Layouts 1.12

Item{

    property alias tariff: textinput.text;
    property string unit;
    property color textcolor: "black";

    property int fontsize: 16;
    property alias inputMask: textinput.inputMask;  //https://doc.qt.io/qt-5/qlineedit.html#inputMask-prop
    property alias maximumLength: textinput.maximumLength;
    property alias acceptableInput: textinput.acceptableInput;

    property alias tariff_validator: textinput.validator;   //Default %

    RowLayout{
        anchors.verticalCenter: parent.verticalCenter;
        Layout.maximumWidth: parent.width
        spacing: 15;
        Label{
            Layout.fillWidth: false;
            text: qsTr("Tarif") + ":"
            color: textcolor;
            font.bold: true;
            font.pointSize: fontsize
        }
        TextInput{
            id: textinput
            Layout.fillWidth: false;
            Layout.preferredWidth: 100;
            horizontalAlignment: TextInput.AlignHCenter;
            color: textcolor;
            font.bold: true;
            font.pointSize: fontsize
            clip: true;
            maximumLength: 5;
            activeFocusOnPress: true;
            validator: DoubleValidator{
                decimals: 1;
                top: 100;
            }
            Rectangle{
                height: 2;
                color: !acceptableInput ? "red" : lkpalette.seperator;
                width: parent.width;
                anchors.bottom: parent.bottom;
            }
            onActiveFocusChanged: {
                if(activeFocus) selectAll();
                else deselect();
            }
        }
        Label{
            Layout.fillWidth: false;
            text: unit;
            color: textcolor;
            font.bold: true;
            font.pointSize: fontsize
        }
    }
}



