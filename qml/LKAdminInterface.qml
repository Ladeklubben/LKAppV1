import QtQuick

QtObject {

    function returnError(res){
        alertbox.setSource("LKAlertBox.qml", {"message": JSON.parse(res).detail.map(item => item.msg).join(", ")});
    }

    function req_users_list(callback){
        http.request("/admin/members", '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                var retval;
                if(o.status === 200) {
                    retval = JSON.parse(o.responseText);

                }
                else if(o.status === 0) {
                    console.log(o.status)
                }
                else{
                    returnError(o.responseText)
                }
                callback(o.status === 200, retval);
            }
        });
    }

    function change_to_user(username, callback){
        http.put("/admin/user/switch?member=" + username, '', function (o) {
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


}
