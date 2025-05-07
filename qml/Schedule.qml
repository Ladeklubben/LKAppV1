import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Item{
    id: sch;
    //property string geturi: '/SETTHIS/'
    property var inf;

    signal itemSelected(var days, var starttime, var interval, var idx);
    signal createNew();
    signal remove(var idx);

    function updateView(){
        sheduleitems.clear();
        for(var j=0; j<schedule.length; j++){
            sheduleitems.append({"Days": JSON.stringify(schedule[j].days), "starttime": schedule[j].start, "intervaltime": schedule[j].interval, "orgidx": j});
        }
    }

    function get_schedules_cb(ok, js){
        if(ok){
            schedule = js;
            schedulewidget.addTime(js);
            schedulewidget.updateView();
        }
    }

    function getSchedules(){
        inf.getSchedules(stationid, get_schedules_cb);
    }


    ListModel{
        id: sheduleitems
    }

    ListView{
        id: lw;
        spacing: 5;
        Layout.fillHeight: false;
        anchors.top: parent.top;
        anchors.bottom: addbutton.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        clip: true;
        model: sheduleitems
        delegate: LKScheduleItem{
            start: starttime;
            interval: intervaltime;
            days: Days;
            width: lw.width;// - 20;
            height: 125;

            onClicked:{
                itemSelected(days, start, interval, orgidx);
            }
            onMovementStarted: lw.interactive = false;
            onMovementEnded: lw.interactive = true;
            onRemove: {
                sch.remove(orgidx)
            }
        }
    }
    LKAddButton{
        id: addbutton;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;

        onClicked: {
            createNew();
        }
    }

    Component.onCompleted: {
        getSchedules();
    }
    onVisibleChanged: {
        if(!visible) return;
        updateView();
    }
}
