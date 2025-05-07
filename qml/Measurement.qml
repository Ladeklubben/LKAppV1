import QtQuick
import PushNotification 1.0
/*
This object takes care of getting the measurements from the backend at interval specified
*/
Item {
    property int appstate: activestate;
    property int lastState;

    property var lastUpdateTime;
    property var schedule_alwayson: stationdata.alwayson;
    property var schedule_openhours: stationdata.openhours;
    property var listprice: stationdata.listprice;

    property string timestamp;

    property bool connection_state: stationdata.online[1];
    property date connection_state_ts: new Date(stationdata.online[0]);

    property real meterval;
    property real phase_l1_w: 0.0;
    property real phase_l2_w: 0.0;
    property real phase_l3_w: 0.0;

    property real phase_l1_i: 0.0;
    property real phase_l2_i: 0.0;
    property real phase_l3_i: 0.0;

    property real phase_l1_v: 0.0;
    property real phase_l2_v: 0.0;
    property real phase_l3_v: 0.0;

    property real phase_sum: 0.0; // (phase_l1_w + phase_l2_w + phase_l3_w).toFixed(2);

    property int autoon: 0;
    property int manon: 0;
    property int gueston: 0;
    property int charging: 0;
    property int connector: 0;
    property int public_availble: 0;

    property bool smart_active;
    property bool smartcharge_ready;
    property int smart_type_active;
    property double smart_charge_start_time;

    property real stat_last_month: 0.0;
    property real stat_month: 0.0;
    property real stat_year: 0.0;
    property real stat_lastyear: 0.0;

    property string tid: "-";
    property real consumptionkWh;

    property string push_subscribe_cmd: "updMeas";
    property var push_update;

    onPush_updateChanged: {
        var js = push_update;

        if("stationid" in js){
            if(activeCharger.id !== js.stationid){
                return;
            }
        }

        if(js.msgtype === "stationupd"){
            updatetimer.restart();
            updateValues(js);
        }
        else if(js.msgtype === "stationstate"){
            readings.charging = parseInt(js.charging);
            readings.autoon = parseInt(js.autoon);
            readings.manon = parseInt(js.manon);
            readings.gueston = parseInt(js.gueston);
            readings.connector = parseInt(js.connector);
            readings.public_availble = parseInt(js['public']);
            readings.smart_active = js['smart_active'];
            readings.smartcharge_ready = js['smartcharge_ready'];
            readings.smart_type_active = js['smart_type_active'];
            readings.smart_charge_start_time = parseFloat(js['smart_charge_start_time'])*1000;
        }
    }


    function updateValues(js){
        // Only update properties if they exist in the response
        timestamp = datetime.format_time(js.timestamp ? js.timestamp * 1000 : Date.now());

        // Use nullish coalescing to provide default values
        phase_sum = (js.TotalActivePower !== undefined ? js.TotalActivePower : 0).toFixed(2);
        meterval = (js.TotalActiveEnergy !== undefined ? js.TotalActiveEnergy : 0).toFixed(2);

        phase_l1_w = (js.phase_l1_w !== undefined ? js.phase_l1_w : 0).toFixed(2);
        phase_l2_w = (js.phase_l2_w !== undefined ? js.phase_l2_w : 0).toFixed(2);
        phase_l3_w = (js.phase_l3_w !== undefined ? js.phase_l3_w : 0).toFixed(2);

        phase_l1_i = (js.phase_l1_i !== undefined ? js.phase_l1_i : 0).toFixed(2);
        phase_l2_i = (js.phase_l2_i !== undefined ? js.phase_l2_i : 0).toFixed(2);
        phase_l3_i = (js.phase_l3_i !== undefined ? js.phase_l3_i : 0).toFixed(2);

        phase_l1_v = (js.phase_l1_v !== undefined ? js.phase_l1_v : 0).toFixed(2);
        phase_l2_v = (js.phase_l2_v !== undefined ? js.phase_l2_v : 0).toFixed(2);
        phase_l3_v = (js.phase_l3_v !== undefined ? js.phase_l3_v : 0).toFixed(2);

        // Safely update tid and consumptionkWh
        if (js.tid !== undefined) {
            tid = js.tid;
        }

        if (js.consumption !== undefined) {
            consumptionkWh = (js.consumption).toFixed(2);
        }
    }

    function updateState(js){
        if (!js || typeof js !== 'object') {
            console.log("updateState: Invalid data received");
            return;
        }

        if("is_charging" in js && js.is_charging !== undefined) charging = parseInt(js.is_charging);
        if("autoon" in js && js.autoon !== undefined) autoon = parseInt(js.autoon);
        if("manon" in js && js.manon !== undefined) manon = parseInt(js.manon);
        if("gueston" in js && js.gueston !== undefined) gueston = parseInt(js.gueston);
        if("connector_occupied" in js && js.connector_occupied !== undefined) connector = parseInt(js.connector_occupied);

        if("online" in js && Array.isArray(js.online) && js.online.length >= 2){
            connection_state = js.online[1];
            connection_state_ts = new Date(js.online[0]);
        }

        if("public" in js && js["public"] !== undefined) public_availble = parseInt(js["public"]);
        if("smart_active" in js && js.smart_active !== undefined) smart_active = js['smart_active'];
        if("smartcharge_ready" in js && js.smartcharge_ready !== undefined) smartcharge_ready = js['smartcharge_ready'];
        if("smart_type_active" in js && js.smart_type_active !== undefined) smart_type_active = parseInt(js['smart_type_active']);
        if("smart_charge_start_time" in js && js.smart_charge_start_time !== undefined) smart_charge_start_time = parseFloat(js['smart_charge_start_time'])*1000;
    }

    function updateStats(js){
        if (!js || typeof js !== 'object') {
            console.log("updateStats: Invalid data received");
            return;
        }

        var now = new Date();
        var year = now.getFullYear();
        var month = now.getMonth() + 1;

        now.setMonth(now.getMonth() - 1);
        var lastyear = now.getFullYear();
        var lastmonth = now.getMonth() + 1;

        // Safe access to nested properties
        stat_month = 0;
        if (js.months && js.months[year] && js.months[year][month] !== undefined) {
            stat_month = (js.months[year][month]).toFixed(2);
        }

        stat_year = 0;
        if (js.years && js.years[year] !== undefined) {
            stat_year = (js.years[year]).toFixed(2);
        }

        stat_last_month = 0;
        if (js.months && js.months[lastyear] && js.months[lastyear][lastmonth] !== undefined) {
            stat_last_month = (js.months[lastyear][lastmonth]).toFixed(2);
        }

        if(lastyear == year){
            lastyear -= 1;
        }

        stat_lastyear = 0;
        if (js.years && js.years[lastyear] !== undefined) {
            stat_lastyear = (js.years[lastyear]).toFixed(2);
        }
    }

    function reqMeasurements(){
        http.request('/cp/' + stationid + '/chargernumbers', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    try {
                        var js = JSON.parse(o.responseText);
                        if (js && typeof js === 'object') {
                            updateValues(js);
                        } else {
                            console.log("reqMeasurement: Invalid response format");
                        }
                    }
                    catch (exception) {
                        console.log("reqMeasurement: Parse error:", exception.message, "Response:", o.responseText);
                    }
                } else {
                    console.log("reqMeasurement: HTTP error:", o.status);
                }
            }
        });
    }

    function reqChargerState(){
        http.request('/cp/' + stationid + '/chargestate', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    try {
                        updateState(JSON.parse(o.responseText));
                    }
                    catch (exception) {
                        console.log("reqChargerState exception 1:", exception.message, o.responseText);
                    }
                }
            }
        });
    }

    function reqStatistics(){
        http.request('/cp/' + stationid + '/stats', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    try {
                        updateStats(JSON.parse(o.responseText));
                    }
                    catch (exception) {
                        console.log("reqChargerState exception 2:", exception.message, o.responseText);
                    }
                }
            }
        });
    }

    function force_update_states(){
        reqChargerState();
    }

    function force_update_statistics(){
        reqStatistics();
    }
    function force_update_measurements(){
        lkinterface.ocpp.req_update_metervalues(stationid, 0);
        reqMeasurements();
    }

    function force_update_all(){
        lkinterface.ocpp.req_update_metervalues(stationid, 0);
        reqChargerState();
        reqStatistics();
        reqMeasurements();
    }

    Timer{
        id: updatetimer;
        property int req_timeout: 0;
        property int update_interval: 1.5*60*1000;
        interval: update_interval;
        running: true;
        repeat: false;

        onTriggered: {
            reqChargerState();
            reqMeasurements();
            reqStatistics();
            req_timeout = Date.now();
            interval = update_interval
            start();
        }

        function request_after_suspend(){
            var now = Date.now();

            //console.log("request_after_suspend", (now - updatetimer.req_timeout) > updatetimer.update_interval)
            if((now - updatetimer.req_timeout) > updatetimer.update_interval){
                reqChargerState();
                reqMeasurements();
                reqStatistics();
                req_timeout = now;
                interval = update_interval;
                running = true;
            }
            else{
                interval = update_interval - (now - req_timeout);
                running = true;
            }
        }
    }


    onEnabledChanged: {
        if(enabled){
            updatetimer.request_after_suspend();
        }
        else{
            updatetimer.stop();
        }
    }

    onAppstateChanged:{
        switch (appstate) {
        case Qt.ApplicationSuspended:
            lastState = Qt.ApplicationSuspended;
            break;
        case Qt.ApplicationHidden:
            break
        case Qt.ApplicationInactive:
            break;
        case Qt.ApplicationActive:
            if(lastState === Qt.ApplicationSuspended){
                updatetimer.request_after_suspend();
            }
            break
        }
        lastState = appstate;
    }

    Component.onCompleted: {
        active_app_section = this;
    }
}
