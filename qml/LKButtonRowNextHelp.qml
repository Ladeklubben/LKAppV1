import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

/* Pass in a next function that this widget can reach */
RowLayout{
    property string help: "";
    property var next;
    property bool enable_next: true;

    spacing: 10;
    height: 75;
    LKButtonV2{
        Layout.fillHeight: true;
        Layout.fillWidth: true;
        enabled: enable_next;
        text: qsTr("Next")
        onClicked: {
            console.log("Click!")
            next();
        }
    }
    LKHelp{
        width: 75;
        Layout.fillHeight: true;
        helpertext: help;
    }
}
