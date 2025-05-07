import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Item{
    property var schedule;
    property var schedule_interface;

    LKStackView{
        id: schedulestack;
        anchors.fill: parent;
        anchors.margins: 5;        
        initialItem: Schedule{
            id: schedulewidget;
            inf: schedule_interface;

            onItemSelected: (days, starttime, interval, idx) => {
                schedulestack.push(editSchedule, {
                                       days: days,
                                       start: starttime,
                                       interval: interval,
                                       orgidx: idx,
                                   });
            }
            onCreateNew: {
                schedulestack.push(addSchedule);
            }

            function delScheduleCb(ok, value){
                if(ok){
                    schedulewidget.getSchedules();
                }
            }

            onRemove: (idx) => {
                schedule_interface.deleteSchedule(stationid, JSON.stringify(schedule[idx]), delScheduleCb);
            }

            function addTime(timeItem){
                schedulestack.pop();    //Does nothing
            }

        }
    }

    Component{
        id: editSchedule
        EditSchedule{

            function updateScheduleCb(ok, value){
                schedulewidget.getSchedules();
            }

            onDone: {
                var timeobj = {
                    'days': JSON.parse(days),
                    'start': start,
                    'interval': interval,
                };

                var o = {
                    'schedule_new': timeobj,
                    'schedule_org': schedule[orgidx],
                }

                schedule_interface.updateSchedule(stationid, JSON.stringify(o), updateScheduleCb);
            }
        }
    }

    Component{
        id: addSchedule;
        AddSchedule{
            function addNewScheduleCb(ok, value){
                schedulewidget.getSchedules();
            }

            onDone: {
                var timeobj = {
                    'days': JSON.parse(days),
                    'start': start,
                    'interval': interval,
                };
                schedule_interface.addNewSchedule(stationid, JSON.stringify(timeobj), addNewScheduleCb);
            }
        }
    }
}



