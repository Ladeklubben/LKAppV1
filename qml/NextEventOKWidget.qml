import QtQuick 2.14
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

/* Shows when the charger will be set on, or how far till it will be off */

MouseArea {
    id: nextOK;
    property bool paused;
    property bool activeTime: false;
    property int relaystate: readings.autoon || readings.manon;

    Rectangle{
        id: background;
        color: lkpalette.base_extra_dark;
        radius: 20;
        anchors.fill: parent;

        ColumnLayout{
            id: layout
            anchors.fill: parent;
            anchors.margins: 20;
            Label{
                id: info
                color: lkpalette.text;
                font.pointSize: lkfont.sizeNormal
                font.bold: true;
            }
            Label{
                id: info_to;
                color: lkpalette.text;
                font.pointSize: lkfont.sizeNormal
            }
        }
    }

    

    onPausedChanged: {
    //    if(paused && !opacityanim.running) opacityanim.start();
    }
    onActiveTimeChanged: {
        paused = relaystate == 0 && activeTime;
    }

    onRelaystateChanged: {
        paused = relaystate == 0 && activeTime;
    }

    Component.onCompleted: {
        paused = relaystate == 0 && activeTime;
    //    if(paused) opacityanim.start();
    }

    LKNextEventTimer{
        id: eventtimer;
        schedule: readings.schedule_alwayson;

        onEventChanged: {
            if(event == event_none){
                nextOK.visible = false;
            }
            else if(event == event_start){
                nextOK.visible = true;
                info.text = qsTr("Locked until")
                info_to.text = event_time;
                activeTime = false;
            }
            else if(event == event_end){
                nextOK.visible = true;
                info.text = qsTr("Unlocked until")
                info_to.text = event_time;
                activeTime = true;
            }
        }
    }
}
