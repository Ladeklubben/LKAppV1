import QtQuick

QtObject{

    function convert_time_string(scheduleobj){
        let start = scheduleobj['start'];
        let stop = start + scheduleobj['interval'];

        let start_hour = parseInt(start/60)
        let start_minute = parseInt(start - start_hour*60);

        let stop_hour = parseInt(stop/60);
        let stop_minute = parseInt(stop - stop_hour*60);

        if(stop_hour > 24) stop_hour = stop_hour - 24;

        start_hour = ("0" + start_hour).slice(-2);
        start_minute = ("0" + start_minute).slice(-2);
        stop_hour = ("0" + stop_hour).slice(-2);
        stop_minute = ("0" + stop_minute).slice(-2);
        return start_hour + ":" + start_minute + " - " + stop_hour + ":" + stop_minute;
    }

    function charger_closed(scheduleobj, next_open_day_idx){
        return datetime.daystring[scheduleobj.days[next_open_day_idx]] + ", " + convert_time_string(scheduleobj);
    }

    function charger_open(scheduleobj){
        if(scheduleobj['interval'] >= 10079){
            return qsTr("Open 24 hours a day");
        }
        return convert_time_string(scheduleobj);
    }

}
