import QtQuick

Item {
    property var stationupd;

    function req_editStation(stationid, data){
        var json = JSON.stringify(data);
        http.put('/cp/' + stationid + '/info', json, function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    for( var i = 0; i < stations.length; i++){
                        if ( stations[i].id === stationid) {
                            Object.assign(stations[i].location, stationupd.location);
                            stationinfo = stationupd.location;
                            header.subtext = stationid + " - " + stationinfo.brief;
                        }
                    }
                    activestack.pop();
                }
                else if(o.status === 0) {
                    alertbox.setSource("LKAlertBox.qml", {"message": "Network error"});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });
    }

    Item{
        anchors.fill: parent;
        anchors.margins: 5;

        CWPlaceCharger{
            id: cwplace;

            anchors.top: parent.top;
            anchors.bottom: buttons.top;
            anchors.left: parent.left;
            anchors.right: parent.right;
        }

        LKButtonRowSubmitHelp{
            id: buttons;
            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            enable_submit: cwplace.changed;

            function submit_result(){
                cwplace.changed = false;
                stationupd = {
                    location: {},
                };

                if(typeof(stationinfo) === 'undefined'){
                    stationinfo = {};
                }
                stationupd.location.brief = cwplace.brief;
                stationupd.location.address = cwplace.address;
                stationupd.location.city = cwplace.city;
                stationupd.location.zip = cwplace.zip;
                stationupd.location.latitude = cwplace.latitude;
                stationupd.location.longitude = cwplace.longitude;


                if(Object.keys(stationupd.location).length == 0){
                    delete stationupd.location;
                }
                else{
                    req_editStation(stationid, stationupd);
                }
            }
            submit: submit_result;
            help: qsTr("Set the location of the charger. " +
                        "Setting this servers 2 purposes. Others will be able to find it, and Ladeklubben will be able to use the right electricity distribution tariffs to calculate right charging prices. \r\n" +
                        "When you zoom enough the address will automatically change"
                       );
        }

    }
}
