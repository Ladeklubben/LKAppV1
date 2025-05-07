import QtQuick 2.13

Item {
    property var data;

    property ListModel free: ListModel{}
    property ListModel flat: ListModel{}
    property ListModel discount: ListModel{}

    function get_groups_list(){
        http.request('/groups/list', '', function (o) {
           if(o.readyState === XMLHttpRequest.DONE){
               if(o.status === 200) {
                   discount.clear();
                   free.clear();
                   flat.clear();
                   data = JSON.parse(o.responseText)
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

    function remove_group(groupid, title){
        let body = JSON.stringify({
                        'title': title,
                       }
                    );
        http.put('/group/' + groupid + '/remove', body, function (o) {
           if(o.readyState === XMLHttpRequest.DONE){
               if(o.status === 200) {
                   get_groups_list();
               }
               else if(o.status === 400){
                   alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Unknown error")});
               }
               else if(o.status === 404){
                   alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Group number not known to the system")});
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


    onDataChanged: {
        try{
            var dgroups = data.DISCOUNT;
            var frgroups = data.FREE;
            var flgroups = data.FLAT;

            discount.clear();
            free.clear();
            flat.clear();

            dgroups.forEach(function(group){
                discount.append({"obj": group, "g_color": lkpalette.g_discount.toString(), "members": group.memberscount});
            });
            frgroups.forEach(function(group){
                free.append({"obj": group, "g_color": lkpalette.g_free.toString(), "members": group.memberscount});
            });
            flgroups.forEach(function(group){
                flat.append({"obj": group, "g_color": lkpalette.g_flat.toString(), "members": group.memberscount});
            });
        }
        catch(error){
            console.log("error", error);
        }
    }
}
