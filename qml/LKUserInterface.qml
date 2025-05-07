import QtQuick

QtObject {
    function returnError(res){
        alertbox.setSource("LKAlertBox.qml", {"message": JSON.parse(res).detail.map(item => item.msg).join(", ")});
    }

    //Endpoints for retrieving user data

    function req_token_refresh(callback){
        http.request("/user/tokenrefresh", "",
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
                                returnError(o.responseText)
                             }
                             callback(o.status === 200, retval);
                         }
                     });
    }

    function req_userinfo(callback){
        http.request("/user/information", "",
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
                                returnError(o.responseText)
                             }
                             callback(o.status === 200, retval);
                         }
                     });
    }

    // Endpoints/Callbacks for updating users

    function reload_user_cb(ok, info){
        if(!ok) return
        userinfo = info['userinfo']
        activestack.pop()
    }

    function updateUser(json){
        http.put('/user/edit', json, function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    req_userinfo(reload_user_cb)
                }
                else if(o.status === 400){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Missing paramters")});
                }
                else if(o.status === 0) {
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                }
                else{
                    returnError(o.responseText)
                }
            }
        });
    }

    function is_user_guest_charging(cb){
        http.request('/user/is_guest_charging', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                let retval;
                if(o.status === 200) {
                    retval = JSON.parse(o.responseText);
                }
                else if(o.status === 0) {
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                }
                else{
                    returnError(o.responseText)
                }
                cb(o.status === 200, retval);
            }
        });

    }

    function add_new_charger(cb){
        http.put('/user/charger/add', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                let retval;
                if(o.status === 200) {
                    retval = JSON.parse(o.responseText);
                }
                else if(o.status === 0) {
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                }
                else{
                    returnError(o.responseText)
                }
                cb(o.status === 200, retval);
            }
        });

    }

    function delete_charger(stationid, cb){
        http.del("/user/charger/remove/" + stationid, "", function(o){
            if(o.readyState === XMLHttpRequest.DONE){
                let retval;
                if(o.status === 200) {
                    retval = JSON.parse(o.responseText);
                }
                else if(o.status === 0) {
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                }
                else{
                    returnError(o.responseText)
                }
                cb(o.status === 200, retval);
            }
        });
    }
}
