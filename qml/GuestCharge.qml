import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12


Item {
    property var stationid;

    property bool claim_is_waiting: false;

    function reqest_claim(){
        guestbutsw.sourceComponent = wait_indicator;
        http.put('/cp/' + stationid + '/claim', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    try {
                        var js= JSON.parse(o.responseText);
                        if(js.claimTimeout === -1){
                            try {
                                charge_preparing();
                            }
                            catch(exception){
                                console.log("reqest_claim exception", exception);
                            }
                        }
                        else{
                            gustwidgetloader.claimtimeend = parseInt(js.claimTimeout * 1000 + Date.now());
                            guestbutsw.sourceComponent = button_charge_start;
                        }
                    }
                    catch (exception) {
                        console.log("Req_claim", exception);
                    }
                }
                else{
                    let err_msg;
                    let err_id;
                    try{
                        let msg = JSON.parse(o.responseText);

                        err_msg = msg.detail.err;
                        err_id = msg.detail.id;
                    }
                    catch (exception){
                        err_msg = qsTr("Something odd happend");
                        err_id = 0;

                        console.log(exception);
                    }
                    console.log(err_id, err_msg);
                    if(o.status === 402){
                        //We need to have a payment card add/updated
                        claim_is_waiting = true;
                        activestack.push(renew)

                    }
                    else if(o.status === 400){
                        console.log(o.status, err_msg);
                    }
                    else if(o.status === 500){
                        var errmsg = JSON.parse(o.responseText);
                        console.log(o.responseText, errmsg.detail.err);
                        alertbox.setSource("LKAlertBox.qml", {"message": qsTr(errmsg.detail.err)});
                    }
                    else if(o.status === 503){
                        let msg;
                        if(err_id === 5){
                            msg = qsTr("Station not active");
                        }
                        else if(err_id === 6){
                            msg = qsTr("Station busy");
                        }
                        else if(err_id === 7){
                            msg = qsTr("Station in manual or automatic mode. Please notify the owner that it need to be released");
                        }
                        alertbox.setSource("LKAlertBox.qml", {"message": msg});
                    }
                    else{
                        alertbox.setSource("LKAlertBox.qml", {"message": err_msg});
                    }
                }
            }
        });
    }

    function request_guest_on(){
        http.put('/cp/' + stationid + '/startcharge', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    charge_preparing();
                }
                else if(o.status === 500){
                    var errmsg = JSON.parse(o.responseText);
                    console.log(o.responseText, errmsg.detail.err);
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Charging station is offline")});
                    guestbutsw.sourceComponent = err_indicator;
                }
                else if(o.status === 503){
                    var errmsg = JSON.parse(o.responseText);
                    console.log(o.responseText, errmsg.detail.err, errmsg.detail.lk_code);

                    if(errmsg.detail.lk_code === 1)
                    {
                        alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Connect charging cable")});
                        guestbutsw.sourceComponent = button_charge_start;
                    }
                    else{
                        alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Charging station is busy")});
                        guestbutsw.sourceComponent = err_indicator;
                    }
                }
                else if(o.status === 0){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });
    }

    function request_guest_off(){
        http.put('/cp/' + stationid + '/stopcharge', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    console.log("Station is stopping..");
                }
                else if(o.status === 0){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });
    }

    function guestcharge_stopped(){
        guestbutsw.sourceComponent = button_disconnect_cable;
        gustwidgetloader.charging = false;
    }

    function guestcharge_started(){
        guestbutsw.sourceComponent = button_charge_stop;
    }

    function charge_preparing(){
        active_charging_session = stationid;
        guestbutsw.sourceComponent = button_charge_preparing;
        gustwidgetloader.sourceComponent = stats;
        gustwidgetloader.item.stationid = stationid;
    }


    Component{
        id: renew;
        CardRenew{
            property string headertext: qsTr("UPDATE CARD")

            onDone: function() {
                //First pop the renew page - its done anyway
                activestack.pop();
                //Next request yet another claim
                reqest_claim();
            }

            onCancel: function(){
                //The user hit the back button - the same as a cancel - go all the way back
                activestack.pop(null);
            }
        }
    }

    Loader{
        id: gustwidgetloader;
        anchors.top: parent.top;
        anchors.bottom: guestbutsw.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        property double claimtimeend;
        property bool charging: false;

        sourceComponent: claimcountdown;

        onSourceComponentChanged: {
        }
    }

    Component{
        id: stats;
        OrderView{
            onOrderstopChanged:{
                if(orderstop){
                    guestcharge_stopped();
                }
                if(charging){
                    guestcharge_started();
                }
            }
            onChargingChanged:{
                if(charging){
                    guestcharge_started();
                }
            }

        }
    }

    Component{
        id: claimcountdown
        Item{
            Label{
                anchors.centerIn: parent;
                property double timeend: claimtimeend;
                color: "White";
                font.pointSize: lkfont.sizeVeryLarge;
                font.bold: true;
                text: "--:--";

                onTimeendChanged: countdowntimer.start();

                Timer{
                    id: countdowntimer;
                    interval: 1000;
                    running: false;
                    repeat: true;
                    onTriggered: {
                        var timeleft = parent.timeend - Date.now();
                        if(timeleft <= 0){
                            stop();
                        }
                        var sec = timeleft/1000;
                        var min = parseInt(sec / 60);
                        sec -= min * 60;
                        sec = parseInt(sec);
                        if(sec < 10) sec = "0" + sec;
                        if(min < 10) min = "0" + min;
                        parent.text = min + ":" + sec;
                    }
                    onRunningChanged: {
                        if(!running){
                            guestbutsw.sourceComponent = button_claim;
                        }
                    }
                }
            }
        }
    }


    Loader{
        id: guestbutsw;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.margins: 15;
        height: 100;
        sourceComponent: infolabel;
    }

    Component{
        id: infolabel;
        Rectangle {
            color: lkpalette.button;
            border.color: lkpalette.border;
            border.width: 2;
            radius: 3

            Label{
                text: qsTr("Waiting...");
                font.pointSize: 18;
                font.bold: true;
                color: "white";
                anchors.centerIn: parent;
            }
        }
    }

    Component{
        id: button_charge_preparing;

        LKButton{

            text: qsTr("PREPARING...");
            enabled: false;
            color: "red";
            textcoler: "white";
        }
    }

    Component{
        id: button_disconnect_cable;

        LKButton{

            text: qsTr("DISCONNECT EV-CABLE");
            enabled: false;
            color: "red";
            textcoler: "white";
        }
    }


    Component{
        id: button_charge_start;

        LKButton{

            text: qsTr("START CHARGE");
            onClicked: {
                guestbutsw.sourceComponent = wait_indicator; //wait_guest_on_indicator;
                request_guest_on();
            }
        }
    }

    Component{
        id: button_charge_stop;

        LKButton{
            text: qsTr("STOP CHARGE");
            onClicked: {
                guestbutsw.sourceComponent = wait_indicator;
                request_guest_off();
            }
        }
    }

    Component{
        id: button_claim;

        LKButton{
            text: qsTr("CLAIM");
            onClicked: {
                reqest_claim();
            }
        }
    }

    Component{
        id: wait_indicator
        LKButton{
            text: qsTr("WAIT");
            enabled: false;
            color: "red";
            textcoler: "white";
        }
    }

    Component{
        id: err_indicator
        LKButton{
            text: qsTr("CHARING NOT POSSIBLE");
            enabled: false;
            color: "red";
            textcoler: "white";
        }
    }

    Component{
        id: wait_guest_on_indicator
        LKButton{
            text: qsTr("PREPARING STATION");
            enabled: false;
            color: "red";
            textcoler: "white";

            Timer{
                id: polltimer;
                interval: 5000;
                running: true;
                repeat: true;
                triggeredOnStart: true;
                onTriggered: {
                    request_guest_on();
                }
                onRunningChanged: {
                }
            }
        }
    }

    Component{
        id: wait_guest_off_indicator
        LKButton{
            text: qsTr("STOPPING STATION");
            enabled: false;
            color: "red";
            textcoler: "white";

            Timer{
                id: polltimer;
                interval: 5000;
                running: true;
                repeat: true;
                triggeredOnStart: true;
                onTriggered: {
                    request_guest_off();
                }
                onRunningChanged: {
                }
            }
        }
    }

    Component.onCompleted: {
        reqest_claim();
    }
    onVisibleChanged: {
        //If we come from a card renew, try claiming againg
        if(visible && claim_is_waiting){
            claim_is_waiting = false;
            reqest_claim();
        }
    }
}
