import QtQuick

QtObject {

    function returnError(res){
        alertbox.setSource("LKAlertBox.qml", {"message": JSON.parse(res).detail.map(item => item.msg).join(", ")});
    }

    function req_orderdetails(orderid, callback){
        let querystring = "?orderid=" + orderid;

        http.request("/order" + querystring, "",
                     function (o) {
                         if(o.readyState === XMLHttpRequest.DONE){
                             var retval;
                             if(o.status === 200) {
                                 retval = JSON.parse(o.responseText);
                             }
                             else if(o.status === 0) {
                                 alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                             }
                             else{
                                returnError(o.responseText);
                             }
                             callback(o.status === 200, retval);
                         }
                     });
    }

    function req_orderno(stationid, callback){
        http.request("/order/" + stationid + "/wait_prepare", "",
                     function (o) {
                         if(o.readyState === XMLHttpRequest.DONE){
                             var retval;
                             if(o.status === 200) {
                                 retval = JSON.parse(o.responseText);
                             }
                             else if(o.status === 0) {
                                 alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                             }
                             else{
                                returnError(o.responseText);
                             }
                             callback(o.status === 200, retval);
                         }
                     });
    }


}
