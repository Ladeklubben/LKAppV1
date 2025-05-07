import QtQuick 2.14
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

/*
    charging == 1
        if power > 30 state == state_charging
        else state == state_idle

    charging == 0
            state = off
*/


MouseArea {
    //Enums
    property int state_checking: 0;
    property int state_idle: 1;
    property int state_charging: 2;
    property int state_off: 3;

    property int connectorstate: readings.connector;
    property int chargingstate: readings.charging;
    property string str_charginfo: qsTr("Checking");

    property real power: readings.phase_sum;
    property int chargerOn : readings.autoon || readings.manon;

    Rectangle {
        id: background;
        color: lkpalette.base_extra_dark
        radius: 20;
        anchors.fill: parent;

        ColumnLayout{
            anchors.fill: parent;
            anchors.margins: 20;
            Label{
                text: qsTr("Active Charging Power");
                color: "white"
                font.pointSize: lkfont.sizeNormal
                font.bold: true;
            }
            Row{
                id: sessioninfo;
                spacing: 25;
                visible: chargingstate === 1;
                Label{
                    text: readings.phase_sum + " kW"
                    color: "white";
                    font.pointSize: lkfont.sizeNormal
                }
                Label{
                    text: readings.consumptionkWh + "kWh"
                    color: "white";
                    font.pointSize: lkfont.sizeNormal
                }
            }
            Label{
                text: str_charginfo;
                color: "white";
                font.pointSize: lkfont.sizeNormal
                visible: sessioninfo.visible != true;
            }
        }

    }

    LKChargeIndicator{
        id: indicator;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        
        chargingstate: parent.chargingstate === 1 ? state_charging : state_off;
        height: 0;
        visible: false;
    }


    function setChargerstate(){
        if(!chargerOn){
            str_charginfo = qsTr("Off");
            if(readings.connector === 1){
                str_charginfo += " - " + qsTr("EV Connected");
            }
        }
        else{
            str_charginfo = qsTr("Ready");
            if(connectorstate == 1){
                str_charginfo += " - " + qsTr("EV Connected");
            }
        }
    }

    onChargingstateChanged: {
        setChargerstate();
    }

    onPowerChanged: {
        //setChargerstate();
    }

    onChargerOnChanged: {
        setChargerstate();
    }

    onConnectorstateChanged: {
        setChargerstate();
    }

//    onEvconnectedChanged: {
//        //setChargerstate();
//    }

    Component.onCompleted: {
        setChargerstate();
    }
}
