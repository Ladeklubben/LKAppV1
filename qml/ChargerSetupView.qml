import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Item{
    id: charger_setup_content;
    property int menuItemHeight: 85;
    //width: parent.width
    Component.onCompleted:{
        header.headText = qsTr("Settings")
        header.subtext = stationinfo.brief?
                      stationid + " - " + stationinfo.brief
                    : stationid
    }

    onVisibleChanged: {
        if (visible) {
            header.headText = qsTr("Settings")
            header.subtext = stationinfo.brief?
                  stationid + " - " + stationinfo.brief
                : stationid
        }
    }

    LKScrollPage {
        height: parent.height;
        width: parent.width;

        content: ColumnLayout{
            id: content;
            anchors.fill: parent;
            anchors.margins: 20;
            spacing: 20;

            LKMenuItem{
                height: menuItemHeight;
                Layout.fillWidth: true
                icon: "\uE801";
                text: qsTr("Charger commands");
                description: qsTr("Set/get charger commands and configurations");
                onClicked: activestack.push(charger_ctrl);
                icon_color: lkpalette.menuItemIcon1
                icon_bk_color: lkpalette.menuItemBackground1;
                visible: false;
            }

            LKMenuItem{
                height: menuItemHeight;
                Layout.fillWidth: true
                icon: "\uE801";
                text: qsTr("Set charger location");
                description: qsTr("Set the location of the charger");
                onClicked: activestack.push(location_setup);
                icon_color: lkpalette.menuItemIcon1
                icon_bk_color: lkpalette.menuItemBackground1
            }

            LKMenuItem{
                height: menuItemHeight;
                Layout.fillWidth: true
                icon: "\uE810";
                text: qsTr("Notifications");
                description: qsTr("Get updates from the charger");
                onClicked: activestack.push(notification_setup);
                icon_color: lkpalette.menuItemIcon2
                icon_bk_color: lkpalette.menuItemBackground2
            }

            LKMenuItem{
                height: menuItemHeight;
                Layout.fillWidth: true
                icon: "\uE811";
                text: qsTr("Opening hours");
                description: qsTr("When guests can use the charger");
                onClicked: activestack.push(publicsetup);
                icon_color: lkpalette.menuItemIcon3
                icon_bk_color: lkpalette.menuItemBackground3
            }

            LKMenuItem{
                height: menuItemHeight;
                Layout.fillWidth: true
                icon: "\uE812";
                text: qsTr("Happy hours");
                description: qsTr("When the charger is free");
                onClicked: activestack.push(alwayson);
                icon_color: lkpalette.menuItemIcon4
                icon_bk_color: lkpalette.menuItemBackground4
            }

            LKMenuItem{
                height: menuItemHeight;
                Layout.fillWidth: true
                icon: "\uE81F";
                text: qsTr("Smart charging");
                description: qsTr("Optimize charging costs");
                onClicked: activestack.push(smartcharging);
                icon_color: lkpalette.menuItemIcon5
                icon_bk_color: lkpalette.menuItemBackground5
            }

            LKMenuItem{
                height: menuItemHeight;
                Layout.fillWidth: true
                icon: "\uE814";
                text: qsTr("Electricity Settlement");
                description: qsTr("Modify electricity settlements");
                onClicked: {
                    activestack.push(settlement);
                    //alertbox.setSource("LKAlertBox.qml", {"message": qsTr("This is still work in progress...")});
                }
                icon_color: lkpalette.menuItemIcon6
                icon_bk_color: lkpalette.menuItemBackground6
            }

            LKMenuItem{
                height: menuItemHeight;
                Layout.fillWidth: true
                icon: "\uE813";
                text: qsTr("Electricity sales price");
                description: qsTr("Set the price for electricity");
                onClicked: activestack.push(listpricesetup);
                icon_color: lkpalette.menuItemIcon7
                icon_bk_color: lkpalette.menuItemBackground7
            }

            LKMenuItem{
                height: menuItemHeight;
                Layout.fillWidth: true
                icon: "\uE80F";
                text: qsTr("Transactions");
                description: qsTr("From this charger");
                onClicked: activestack.push(transactionsview);
                icon_color: lkpalette.menuItemIcon8
                icon_bk_color: lkpalette.menuItemBackground8
            }

            LKMenuItem{
                height: menuItemHeight;
                Layout.fillWidth: true
                icon: "\uE80C";
                text: qsTr("QR-Tag");
                description: qsTr("Set up QR-Tag for the charger");
                onClicked: activestack.push(qr_setup);
                icon_color: lkpalette.menuItemIcon1
                icon_bk_color: lkpalette.menuItemBackground1
            }

            LKMenuItem {
                height: menuItemHeight
                Layout.fillWidth: true
                icon: "\uE80B"
                color: lkpalette.menuWarningBackground
                text: qsTr("Delete this charger")
                description: qsTr("Remove this charger from your account")
                onClicked: {
                    alertbox.setSource("ChargerRemoveWarning.qml", {'stationid': stationid});
                }
                icon_color: lkpalette.menuItemIcon6
                icon_bk_color: lkpalette.menuItemBackground6
            }
            Item{
                height: 20;
                Layout.fillWidth: true
            }
        }

        Component{
            id: location_setup
            ChargerLocation{
               // property string headertext: qsTr("PLACE STATION")
            }
        }

        Component{
            id: notification_setup
            ChargerNotificationSetup{
            //    property string headertext: qsTr("NOTIFICATIONS");
            }
        }

        Component{
            id: publicsetup;
            PublicSetup{ // AKA opening hours
            //    property string headertext: qsTr("OPENING hours");
                ispublic: readings.public_availble;
            }
        }


        Component{
            id: alwayson;
            AlwaysOn{// AKA happy hours
            //    property string headertext: qsTr("ALWAYS-ON hours");
                schedule: readings.schedule_alwayson;
                Component.onDestruction: {
                    readings.schedule_alwayson = schedule;
                }
            }
        }

        Component{
            id: smartcharging
            SmartCharging{
            //    property string headertext: qsTr("SMART CHARGING");
            }
        }

        Component{
            id: settlement;
            LKElecticitySettlementSetup{
            //    property string headertext: qsTr("ELECTRICITY SETTLEMENT");
            }
        }

        Component{
            id: listpricesetup
            ListPriceSetup{
            //    property string headertext: qsTr("STANDARD PRICE SETUP");
            }
        }

        Component{
            id: transactionsview;
            Transactions{
            //    property string headertext: qsTr("TRANSACTIONS");
            }
        }

        Component{
            id: qr_setup
            QRSetupView{
            //    property string headertext: qsTr("QR-TAG SETUP");
            }
        }


        Component{ // Not used as far as i can see
            id: test;
            LKDatePicker{

            }
        }

        Component{
            id: charger_ctrl
            ChargerCntrl{

            }
        }
    }
}
