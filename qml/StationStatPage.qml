import QtQuick
Item{
    LKRotation{
        anchors.fill: parent;

        rotitem: LKStatBarChart{
            id: chart;
            property var stats;
            property int chosen_year;
            property int chosen_month;
            property int chosen_day;

            property var callback;

            function dig_deeper_years(index, value){
                chosen_year = 0; chosen_month = 0; chosen_day = 0;
                set_plot();
            }

            function dig_deeper_year(index, value){
                chosen_year = value; chosen_month = 0; chosen_day = 0;
                set_plot();
            }

            function dig_deeper_month(index, value){
                chosen_month = index+1; chosen_day = 0;
                set_plot();
            }

            function dig_deeper_day(index, value){
                chosen_day = index + 1;
                set_plot();
            }

            function set_years_plot(){
                let v = stats.years;
                callback = dig_deeper_year;
                update_plot(dig_deeper_year, "", v);
            }

            function set_year_plot(year){
                let v = stats.months[chosen_year];
                callback = dig_deeper_month;
                update_plot(dig_deeper_month, chosen_year, v, datetime.monthstring);
            }

            function update_stats_cb(ok, data){
                /* Update stats variable with the days data */
                let year = data['year'];
                let month = data['month'];
                let days = data['days'];
                if(!('days' in stats)) stats['days'] = {};
                if(!(year in stats['days'])) stats['days'][year] = {};
                if(!(month in stats['days'][year])) stats['days'][year][month] = days;
                set_plot();
            }

            function set_month_plot(){
                /* If we have the data already, just use those data. */
                if(!('days' in stats && chosen_year in stats['days'] && chosen_month in stats['days'][chosen_year])){
                    lkinterface.charger.req_stats(activeCharger.id, chosen_year, chosen_month, null, update_stats_cb);
                    return;
                }
                callback = dig_deeper_day;
                update_plot(dig_deeper_day, datetime.monthstring[chosen_month-1] + " - " + chosen_year, stats['days'][chosen_year][chosen_month]);
            }

            function update_hours_stat_cb(ok, data){
                /* Update stats variable with the days data */
                let year = data['year'];
                let month = data['month'];
                let day = data['day'];
                let hours = data['hours'];
                if(!('hours' in stats)) stats['hours'] = {};
                if(!(year in stats['hours'])) stats['hours'][year] = {};
                if(!(month in stats['hours'][year])) stats['hours'][year][month] = {};
                if(!(day in stats['hours'][year][month])) stats['hours'][year][month][day] = hours;

                set_plot();
            }

            function set_day_plot(){
                /* If we have the data already, just use those data. */
                if(!('hours' in stats && chosen_year in stats['hours'] && chosen_month in stats['hours'][chosen_year] && chosen_day in stats['hours'][chosen_year][chosen_month])){
                    lkinterface.charger.req_stats(activeCharger.id, chosen_year, chosen_month, chosen_day, update_hours_stat_cb);
                    return;
                }
                callback = null;
                update_plot(null, chosen_day + " - " + datetime.monthstring[chosen_month-1] + " - " + chosen_year, stats['hours'][chosen_year][chosen_month][chosen_day]);
            }

            function set_plot(){
                if(chosen_day > 0){
                    set_day_plot();
                }
                else if(chosen_month > 0){
                    set_month_plot();
                }
                else if(chosen_year > 0){
                    set_year_plot();
                }
                else{
                    set_years_plot();
                }
            }

            onDig_deeper: function(index, value){
                if(callback) callback(index, value);
            }

            function stats_cb(ok, data){
                stats = data;
                set_plot();
            }

            Component.onCompleted: {
                lkinterface.charger.req_stats(activeCharger.id, null, null, null, stats_cb);
                header.headText = qsTr("STATISTICS")
            }

            LKIconButton{
                anchors.bottom: parent.bottom;
                anchors.right: parent.right;
                anchors.margins: 5;
                height: 40;
                width: 40;
                text: "\uE81C";
                color: lkpalette.base_light;
                visible: chosen_year > 0;
                enabled: visible;
                onClicked: {
                    if(chosen_day > 0) chosen_day = 0;
                    else if(chosen_month > 0) chosen_month = 0;
                    else if(chosen_year > 0) chosen_year = 0;
                    set_plot();
                }
            }
        }
    }
}

