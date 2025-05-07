import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Item {
    id: stationPage
    property var stationid;
    property var stationinfo;   //Information about where it is placed. Its name, gps location, address etc
    property var stationtype;   //Contains information about the charger - is it smart, maximum power, connector type etc.
    Item {
        id: menu

        anchors.fill: parent;

        Rectangle{
            //Indicator to show if a charger is online or not
            height: 2;
            anchors{
                top: parent.top;
                left: parent.left;
                right: parent.right;
            }
            color: isOnline ? lkpalette.signalgreen : lkpalette.error;
        }

        LKScrollPage {
            refreshEnable: true;
            height: parent.height - buttonbar.height
            width: parent.width;

            onUpdateView:{
                readings.force_update_all();
            }

            //Main content
            content: ColumnLayout{
                id: pagecontent;
                anchors.fill: parent;
                anchors.margins: 20;
                spacing: 20;

                ChargerState{

                    LKIcon{
                       // text: nexticon
                        font.pointSize: 18;
                        anchors.verticalCenter: parent.verticalCenter;
                        anchors.right: parent.right;
                        anchors.margins: 20;
                    }

                    Layout.fillHeight: true;
                    Layout.fillWidth: true;
                    Layout.preferredHeight: 140;
                    Layout.minimumHeight: 75;
                    onClicked: {
                        activestack.push(readingsdetail)
                    }
                }

                Rectangle {
                    id: chargerStatRect
                    Layout.fillWidth: true;
                    Layout.fillHeight: true;
                    Layout.minimumHeight: 175;
                    color: lkpalette.base_extra_dark
                    anchors.margins: 0;
                    radius: 20;

                    ChargerStat{
                        id: chargerstat;
                        anchors.margins: 20;
                        anchors.fill: parent;

                        LKIcon{
                            // text: nexticon
                            font.pointSize: 18;
                            anchors.verticalCenter: parent.verticalCenter;
                            anchors.right: parent.right;
                            anchors.margins: 0;
                        }
                        onClicked: {
                            activestack.push(statpage);
                        }
                    }
                }

                NextEventOKWidget{
                    id: okWidget
                    Layout.fillHeight: true;
                    Layout.fillWidth: true;
                    Layout.maximumHeight: 150;
                    Layout.preferredHeight: 100;
                    Layout.minimumHeight: 75;
                }

                NextEventOPENWidget{
                    id: openWidget
                    Layout.fillHeight: true;
                    Layout.fillWidth: true;
                    Layout.maximumHeight: 150;
                    Layout.preferredHeight: 100;
                    Layout.minimumHeight: 75;
                }
                LKSmartCtrl{
                    visible: readings.smart_active;
                    Layout.fillWidth: true;
                    Layout.preferredHeight: 200;
                    smart_operation_enabled: readings.smartcharge_ready;
                    active_state: readings.smart_type_active;
                    smart_charge_start_time: readings.smart_charge_start_time;
                    onSchedule_plot_clicked: activestack.push(smartpage);
                }
            }
        }

        Rectangle {
            id: buttonbar;
            height: 100;
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            color: lkpalette.base_extra_dark;

            LKChargerButton{
                id: button_unlock;
                width: parent.width;
                height: parent.height;
                anchors.margins: 20;
                anchors {
                    left: parent.left;
                    right: settingsBg.left;
                    top: parent.top;
                    bottom: parent.bottom;
                }
            }

            Rectangle {
                id: settingsBg;
                height: 60;
                width: 60;
                color: lkpalette.menuItemBackground1;
                radius: 20;
                anchors.margins: 20;
                anchors {
                    right: parent.right;
                    top: parent.top;
                    bottom: parent.bottom;
                }

                LKIconButton{
                    id: charger_setup_but;
                    color: lkpalette.menuItemIcon1;
                    height: parent.height;
                    text: "\uE800"
                    pointsize: 18;
                    anchors.fill: parent;
                }

                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        activestack.push(charger_setup);
                    }
                }
            }
        }
    }


    // Component {

    //     Item{
    //         property string nexticon: "\uE808";
    //         property string headertext: qsTr("OVERVIEW");
    //     }
    // }

    Component{
        id: readingsdetail;

        Active {
            property string headertext: qsTr("POWER DETAILS")
        }
    }

    Component{
        id: transactionsview;

        Transactions{
            property string headertext: qsTr("TRANSACTIONS");
        }
    }

    Component{
        id: charger_setup;

        ChargerSetupView{
           // property string headertext: qsTr("SETUP");
        }
    }

    Component{
        id: statpage;

        StationStatPage{
            property string headertext: qsTr("STATISTICS");
        }
    }

    Component{
        id: publicsetup;

        PublicSetup{
            property string headertext: qsTr("OPENING hours");
            ispublic: readings.public_availble;
        }
    }

    Component{
        id: smartpage;
        SmartView{
            property string headertext: qsTr("ACTIVE SMART SETUP");
        }
    }
}
