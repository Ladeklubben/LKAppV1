import QtQuick
import QtQuick.Layouts

/* Pass in a next function that this widget can rech */
RowLayout{
    property string help: "";
    property var submit;
    property bool enable_submit: true;

    spacing: 10;
    height: 50;
    LKButtonV2{
        Layout.fillHeight: true;
        Layout.fillWidth: true;
        enabled: enable_submit;
        text: qsTr("Submit")
        onClicked: {
            submit();
        }
    }
    LKHelp{
        width: 75;
        Layout.fillHeight: true;
        helpertext: help;
    }
}
