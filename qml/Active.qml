import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Item{
    id: charger_setup_content;
    property int menuItemHeight: 85;

    property alias l1_val: l1_now.value;
    property alias l2_val: l2_now.value;
    property alias l3_val: l3_now.value;
    property alias sum_val: sum.value;

    Component.onCompleted: {
        header.headText = qsTr("POWER DETAILS")
    }

    LKScrollPage {
        refreshEnable: true;
        anchors.fill: parent;

        onUpdateView:{
            readings.force_update_all();
        }

        content:Column{
            id: content;
            anchors.fill: parent;
            anchors.margins: 20;
            spacing: 20;

            LKValueTag{
                id: l1_now;
                width: parent.width;
                anchors.left: parent.left;
                icon: "\uE801";
                text: qsTr("Phase L1");
                description: qsTr("Live");
                icon_color: lkpalette.menuItemIcon1
                icon_bk_color: lkpalette.menuItemBackground1
                unit: "W"
                value: readings.phase_l1_w;
            }

            LKValueTag{
                id: l2_now;
                width: parent.width;
                anchors.left: parent.left;
                icon: "\uE801";
                text: qsTr("Phase L2");
                description: qsTr("Live");
                icon_color: lkpalette.menuItemIcon1
                icon_bk_color: lkpalette.menuItemBackground1
                unit: "W"
                value: readings.phase_l2_w;
            }

            LKValueTag{
                id: l3_now;
                width: parent.width;
                anchors.left: parent.left;
                icon: "\uE801";
                text: qsTr("Phase L3");
                description: qsTr("Live");
                icon_color: lkpalette.menuItemIcon1
                icon_bk_color: lkpalette.menuItemBackground1
                unit: "W"
                value: readings.phase_l3_w;
            }

            LKValueTag{
                id: sum;
                width: parent.width;
                anchors.left: parent.left;
                icon: "\uE801";
                text: qsTr("Sum");
                description: qsTr("Live");
                icon_color: lkpalette.menuItemIcon1
                icon_bk_color: lkpalette.menuItemBackground1
                unit: "kW"
                value: readings.phase_sum;
            }

            LKValueTag{
                id: active_session;
                width: parent.width;
                anchors.left: parent.left;
                icon: "\uE801";
                text: qsTr("Session");
                description: qsTr("Latest charge");
                icon_color: lkpalette.menuItemIcon1
                icon_bk_color: lkpalette.menuItemBackground1
                unit: "kWh"
                value: readings.consumptionkWh;
            }

            LKValueTag{
                id: metervalue;
                width: parent.width;
                anchors.left: parent.left;
                icon: "\uE801";
                text: qsTr("Charger");
                description: qsTr("Meter value");
                icon_color: lkpalette.menuItemIcon1
                icon_bk_color: lkpalette.menuItemBackground1
                unit: "kWh"
                value: readings.meterval;
            }

            Label{
                text: qsTr("Last updated: ") + readings.timestamp;
                color: lkpalette.base_white
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
