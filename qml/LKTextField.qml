import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

RowLayout{
    Layout.fillWidth: true;
    Layout.fillHeight: false;
    property alias name: namefield.text;
    property alias text: textfield.text;

    Label{
        id: namefield;
        color: "white"
    }
    Label{
        id: textfield;
        color: "white";
    }
}
