import QtQuick 2.13

QtObject {
    property var daystring: [qsTr("Monday"), qsTr("Tuesday"), qsTr("Wednesday"), qsTr("Thursday"), qsTr("Friday"), qsTr("Saturday"), qsTr("Sunday")];
    property var monthstring: [qsTr("January"), qsTr("February"), qsTr("March"), qsTr("April"), qsTr("May"), qsTr("June"), qsTr("July"), qsTr("August"), qsTr("September"), qsTr("October"), qsTr("November"), qsTr("December")]

    property var start_today_epoch;

    function format_time(epoch_ms){
        var t = new Date(epoch_ms);
        let date = ("0" + t.getDate()).slice(-2);
        let month = ("0" + (t.getMonth() + 1)).slice(-2);
        let hour = ("0" + t.getHours()).slice(-2);
        let minute = ("0" + t.getMinutes()).slice(-2);
        let sec = ("0" + t.getSeconds()).slice(-2);

        return date + '.' + month + '.' + t.getFullYear() + ' ' + hour + '.' + minute + '.' + sec;
    }

    function format_date(epoch_ms){
        var t = new Date(epoch_ms);
        let date = ("0" + t.getDate()).slice(-2);
        let month = ("0" + (t.getMonth() + 1)).slice(-2);

        return date + '.' + month + '.' + t.getFullYear();
    }

    function seconds_to_days_hours_mins_secs_str(seconds)
    { // day, h, m and s
        var days     = Math.floor(seconds / (24*60*60));
        seconds -= days    * (24*60*60);
        var hours    = Math.floor(seconds / (60*60));
        seconds -= hours   * (60*60);
        var minutes  = Math.floor(seconds / (60));
        seconds -= minutes * (60);
        return ((0<days)?(days+" dage, "):"")+hours+"t, "+minutes+"m og "+seconds+"s";
    }

    function epoch_start_hour(epoch_sec){
        let t = parseInt(parseInt(epoch_sec/3600)*3600);
        return t;
    }

    Component.onCompleted: {
        var date = new Date();
        var day = date.getDate();
        var month = date.getMonth();
        var year = date.getFullYear()
        var d = new Date(year, month, day);
        d = d.getTime();
        start_today_epoch = d;
    }
}
