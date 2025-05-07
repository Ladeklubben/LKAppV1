import QtQuick

QtObject {
    property string geturi;
    property string edituri;

    function returnError(res){
        alertbox.setSource("LKAlertBox.qml", {"message": JSON.parse(res).detail.map(item => item.msg).join(", ")});
    }

    function addNewSchedule(stationid, json, callback){
        http.patch('/schedule/' + stationid + geturi, json, function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                var retval;
                if(o.status === 200) {
                    retval = JSON.parse(o.responseText);
                }
                else if(o.status === 0){
                    alertbox.setSource("LKAlertBox.qml", {"message": "Network error"});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
                callback(o.status === 200, retval);
            }
        });
    }

    function updateSchedule(stationid, json, callback){
        http.put('/schedule/' + stationid + geturi, json, function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                var retval;
                if(o.status === 200) {
                    retval = JSON.parse(o.responseText);
                }
                else if(o.status === 0){
                    alertbox.setSource("LKAlertBox.qml", {"message": "Network error"});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
                callback(o.status === 200, retval);
            }
        });
    }


    function deleteSchedule(stationid, body, callback){
        http.put('/schedule/' + stationid + edituri + "/rm", body, function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                var retval;
                if(o.status === 200) {
                    retval = JSON.parse(o.responseText);
                }
                else if(o.status === 0){
                    alertbox.setSource("LKAlertBox.qml", {"message": "Network error"});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
                callback(o.status === 200, retval);
            }
        });
    }

    function getSchedules(stationid, callback){
        http.request('/schedule/' + stationid + geturi, '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                var retval;
                if(o.status === 200) {
                    retval = JSON.parse(o.responseText);;
                }
                else if(o.status === 0){
                    alertbox.setSource("LKAlertBox.qml", {"message": "Network error"});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
                callback(o.status === 200, retval);
            }
        });
    }
}
