import QtQuick 2.0
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Item{
    property alias kwh_val: kwh_total.value;
    property alias kr_val: kr_total.value;
    property alias refkr_val: refusion_total.value;

    ColumnLayout{
        spacing: 5;
        Layout.fillHeight: false;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.margins: 5;

        LKTag{
            id: kwh_total;
            tagname: "Total";
            value: "---.--"
            unit: "kWh"
            Layout.preferredHeight: 100;
            Layout.fillWidth: true;
        }
        LKTag{
            id: kr_total;
            value: "---.--"
            tagname: "Pris";
            unit: "kr"
            Layout.preferredHeight: 100;
            Layout.fillWidth: true;
        }
        LKTag{
            id: refusion_total;
            value: "---.--"
            tagname: "Refusion";
            unit: "kr"
            Layout.preferredHeight: 100;
            Layout.fillWidth: true;
        }
    }
}
