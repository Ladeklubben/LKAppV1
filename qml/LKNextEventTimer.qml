import QtQuick 2.0




Timer{
    id: nextupdate;

    property var schedule;

    property int event_start: 1;
    property int event_end: 2;
    property int event_none: 3;

    property int event;
    property string event_time;

    repeat: false;

    function setNextEvent(){
        /* Only a change on the event flag will cause a trigger, this way set it to none no-matter*/
        event = event_none;
        if(schedule.length === 0){
            return;
        }

        var dt = new Date()

        var now_day = dt.getDay() - 1;
        now_day = now_day < 0 ? 6 : now_day;

        const now = now_day * 24 * 60 + dt.getHours() * 60 + dt.getMinutes();

        var nextmin = 9999999;
        var nextstart;
        //info.text = "ON at:"
        var tmpevent = event_start;
        var found = 0;
        for(var j=0; j<schedule.length; j++){
            for(var i=0; i<schedule[j]['days'].length; i++){
                var starttime = schedule[j]['days'][i]*24*60 + schedule[j]['start']
                var stoptime = starttime + schedule[j]['interval']
                var tmp;
                if(now >= starttime && now < stoptime){
                    nextstart = stoptime;
                    //info.text = "OFF at:"
                    tmpevent = event_end;
                    nextmin = stoptime - now;
                    found = 1;
                    break;
                }
                else if(now > starttime){
                    tmp = (starttime + 24*7*60) - now;
                    if(nextmin > tmp){
                        nextmin = tmp;
                        nextstart = starttime;
                    }
                }
                else{
                    tmp = starttime - now;
                    if(nextmin > tmp){
                        nextmin = tmp;
                        nextstart = starttime;
                    }
                }
            }

            if(found) break;
        }
        var day = parseInt(nextstart/(24*60));  nextstart -= day * 24 * 60;
        var hour = parseInt(nextstart/60); nextstart -= hour * 60;
        var min = nextstart;

        day = day > 6 ? day - 7 : day;
        min = min > 9 ? min : "0"+min.toString();
        hour = hour > 9 ? hour : "0"+hour.toString();

        //to.text = daystring[day] + " " + hour +":" + min;
        event_time = datetime.daystring[day] + " " + hour +":" + min;
        nextupdate.interval = (nextmin * 60 - dt.getSeconds() + 1) * 1000;
        nextupdate.running = true;
        event = tmpevent;
    }

    onScheduleChanged: {
        nextupdate.running = false;
        setNextEvent();
    }

    onTriggered: {
        setNextEvent();
    }

}
