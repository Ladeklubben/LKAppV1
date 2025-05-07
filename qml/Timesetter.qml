import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Column{
    id: ts;
    anchors.left: parent.left;
    anchors.right: parent.right;
    anchors.top: parent.top;
    spacing: 25;

    property int starttime;
    property int interval;
    property string days: "[]";

    Rectangle{
        radius: 5;
        width: parent.width;
        height: 200;
        color: lkpalette.base_light;

        LKScheduleDayItem{
            id: daysetter;
            height: 50;
            anchors.top: parent.top;
            anchors.right: parent.right;
            anchors.left: parent.left;
            anchors.margins: 10;

            onDaysChanged: {
                days = JSON.stringify(get_days_active())
            }
        }
        LKScheduleTimeItem{
            id: timesetter;
            anchors.bottom: parent.bottom;
            anchors.right: parent.right;
            anchors.left: parent.left;
            anchors.margins: 10;

            height: 100;

            function update(){
                if(starthour == '' || startminute == '' || tohour == '' || tominute == '') return;
                let st = parseInt(starthour) * 60 + parseInt(startminute);
                let it = (parseInt(tohour) * 60 + parseInt(tominute)) - st;

                if(st !== starttime){
                    starttime = st;
                }
                if(it < 0) it += 24*60;
                if(interval !== it){
                    interval = it;
                }
            }

            onStartChanged: {
                update();
            }
            onStopChanged: {
                update();
            }
        }
    }

    Component.onCompleted: {
        var hour_from = parseInt(starttime / 60);
        var minute_from = parseInt(starttime - (hour_from * 60));

        let stoptime = starttime + interval;
        if(stoptime > 24*60){
            stoptime -= 24*60;
        }

        var hour_to = parseInt(stoptime / 60);
        var minute_to = parseInt(stoptime - (hour_to * 60));


        hour_from = ("0" + hour_from).slice(-2);
        minute_from = ("0" + minute_from).slice(-2);

        hour_to = ("0" + hour_to).slice(-2);
        minute_to = ("0" + minute_to).slice(-2);

        timesetter.starthour = hour_from;
        timesetter.startminute = minute_from;
        timesetter.tohour = hour_to;
        timesetter.tominute = minute_to;

        var d = JSON.parse(days);
        for(let i=0; i<d.length; i++){
            daysetter.set_day_active(d[i]);
        }
    }
}
