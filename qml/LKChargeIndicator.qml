import QtQuick 2.14
import QtQuick.Shapes 1.14
import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

/*
ChargerON = true:
    charging = True => bar will run and indicate charging
    charging = False => bar will be completely green

ChargerON = false:
    charging = True => bar will run and indicate charging
    charging = False => bar will be completely off
*/

Rectangle {
    id: button
    property int barwidth: 20;
    property int chargingstate;

    function updateView(){
        baritems.append({"color": "#c6f200ff"});
    }

    color: "transparent";
    border.color: lkpalette.base_white;
    border.width: 1;
    radius: 5;

    ListModel{
        id: baritems
    }

    ListView{
        spacing: 1;
        Layout.fillWidth: false;
        anchors.margins: 5;
        anchors.fill: parent;
        layoutDirection: Qt.LeftToRight
        clip: true;
        model: baritems
        orientation: ListView.Horizontal;
        interactive: false;
        delegate:   Rectangle{
            color: lkpalette.signalgreen;
            width: barwidth;
            height: 20;
            Layout.fillHeight: true;
        }

        onContentWidthChanged: {
            if(parent.width < contentWidth){
                if(chargingstate == state_charging){
                    baritems.clear();
                }
                else if(chargingstate == state_off){
                    shifttimer.running = false;
                    baritems.clear();
                }
                else if(chargingstate == state_idle){
                    shifttimer.running = false;
                }
            }
        }
    }

    Timer{
        id: shifttimer;
        running: true;
        interval: 800;
        repeat: true;
        triggeredOnStart: true;
        onTriggered: {
            updateView();
        }
    }

    onChargingstateChanged: {
        if(chargingstate == state_charging ){
            baritems.clear();
            shifttimer.interval = 500;
            shifttimer.running = true;
        }
        else if(chargingstate == state_idle){
            baritems.clear();
            shifttimer.interval = 100;
            shifttimer.running = true;
        }
        else if(chargingstate == state_off){
            baritems.clear();
        }
    }

    Component.onCompleted: {
        shifttimer.interval = 100;
        shifttimer.running = true;
    }
}

