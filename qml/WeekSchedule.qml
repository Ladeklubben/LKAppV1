import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

ColumnLayout{
    spacing: 5;
    Layout.fillHeight: false;
    Layout.fillWidth: true;

    Repeater{
        width: parent.width;
        model: [qsTr("Monday"), qsTr("Tuesday"), qsTr("Wensday"), qsTr("Thursday"), qsTr("Friday"), qsTr("Saturday"), qsTr("Sunday")];
        DayHours{
            width: parent.width;
            weekday: modelData;
        }
    }
}
