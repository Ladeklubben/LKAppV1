import QtQuick

QtObject {
    function returnError(res){
        alertbox.setSource("LKAlertBox.qml", {"message": JSON.parse(res).detail.map(item => item.msg).join(", ")});
    }

    function requestOrderinfo(chargepoint, callback){
        http.request('/cs/' + chargepoint + '/activeguest', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                var retval;
                if(o.status === 200) {
                    var text = o.responseText;
                    try{
                        retval = JSON.parse(o.responseText);
                        // updateValues(JSON.parse(o.responseText));
                    }
                    catch(exception){

                    }
                }
                else if(o.status === 0){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                }
                else{
                    console.log("requestOrderinfo code:", o.status);
                    returnError(o.responseText);
                }
                callback(o.status === 200, retval);
            }
        });
    }
}
