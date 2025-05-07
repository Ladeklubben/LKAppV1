import QtQuick 2.13
import PushNotification 1.0

Item {
    property int last_map_update: -1;
    property string push_subscribe_cmd: "updMap";
    property var push_update;

    property var qr_to_station_list: ({});

    function get_station_from_qr(qrcode){
        if(qrcode in qr_to_station_list){
            return qr_to_station_list[qrcode];
        }
        return null;
    }

    function get_stationobj(stationid_string){
        for(var i=0; i<list_of_markers.count; i++){
            var o = list_of_markers.get(i).stationobj;
            if(o.stationid === stationid_string){
                return o;
            }
        }
    }

    onPush_updateChanged: {
        var js = push_update;

        if(!(js.msgtype === "mapupd"))
            return;

        last_map_update = js.updatetime;
        update_mapitemslist(js.upd);
    }


    function update_mapitemslist(mapinfoobj){
        polltimer.restart();
        var c = Qt.createComponent("LKMapDataItem.qml");
        mapinfoobj.forEach(function(item){
            for(var i=0; i<list_of_markers.count; i++){
                var o = list_of_markers.get(i).stationobj;
                if(o.stationid === item.stationid){

                    if(!('location' in item)){
                        o.destroy();
                        list_of_markers.remove(i);
                    }
                    else{
                        o.update(item);
                    }
                    return;
                }
            }


            if(!('location' in item)){
                return;
            }

            var obj = c.createObject(mdata, {obj: item, member_price: guestgroups.get_guest_group_item(item.stationid)});
            list_of_markers.append({'stationobj': obj});

            if('qr' in item){
                qr_to_station_list[item.qr] = obj;
            }
        });
    }

    function poll_stationmap()
    {
        polltimer.restart();
        let url = '/chargermap'
        if(last_map_update > 0){
            url += "?lastupdate=" +last_map_update;
        }

        http.request(url, '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    try {
                        var text = o.responseText;
                        var js= JSON.parse(o.responseText);
                        last_map_update = js.updatetime;
                        update_mapitemslist(js.upd);
                    }
                    catch (exception) {
                        console.log("chargermap", exception.message, o.responseText);
                    }
                }
            }
        });
    }

    Timer{
        id: polltimer;
        interval: 2*60*1000;
        triggeredOnStart: false;
        repeat: true;
        onTriggered: {
            poll_stationmap();
        }
    }

    Component.onCompleted: {
        active_app_section = this;
        poll_stationmap();
        polltimer.start();
    }
}
