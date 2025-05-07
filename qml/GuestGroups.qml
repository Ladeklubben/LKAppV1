import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12


Item {
    property ListModel guest_stations: ListModel{};
    property ListModel guest_pending_invites: ListModel{};
    signal guestgroup_added(var stationid);

    property var guest_station_map: ({});

    function get_guest_group_item(station){
        if(station in guest_station_map){
            return guest_station_map[station];
        }
        return no_group_default;
    }

    LKMemberPriceSetup{
        id: no_group_default;
    }

/*
Data is stored as:
    {
        "DISCOUNT":{
                "stations":["2754636038","A10215111081"],
                "2754636038":10,
                "A10215111081":50},
        "FREE":{
                "stations":["2754636038"]},
        "FLAT":{
                "stations":["2754636038"]}}

    The stations key is a list of all stations in the group DISCOUNT, FLAT or FREE.

*/
    property var data;
    property var pending_invites;

    function update_groups(dataset){
        var c = Qt.createComponent("LKMemberPriceSetup.qml");

        var allgroups = {};
        for(var i=0; i<guest_stations.count; i++){
            var o = guest_stations.get(i);
            allgroups[(o.stationid)] = i;
        }
        const s = new Set();
        dataset.DISCOUNT.stations.forEach(function(item){
            s.add(item);
        });
        dataset.FLAT.stations.forEach(function(item){
            s.add(item);
        });
        dataset.FREE.stations.forEach(function(item){
            s.add(item);
        });

        for(const item of s){
            var obj;
            //First update if its one we know
            if(item in allgroups){
                var o = guest_stations.get(allgroups[item]).stationobj;
                if(item in dataset.FLAT.stations){
                    o.flat = true;
                }
                else{
                    o.flat = false;
                }
                if(item in dataset.FREE.stations){
                    o.free = true;
                }
                else{
                    o.free = false;
                }
                if(item in dataset.DISCOUNT.stations){
                    o.discount_tariff = dataset['DISCOUNT'][item];
                }
                else{
                    o.discount_tariff = 0;
                }

                delete allgroups[item];
            }
            else{
                //Next create the new ones
                    var free = dataset.FREE.stations.includes(item);
                    var flat = dataset.FLAT.stations.includes(item);
                    obj = c.createObject(guestgroups, {'stationid': item, "flat": flat, "free": free, "discount_tariff": dataset.DISCOUNT.stations.includes(item) ? dataset['DISCOUNT'][item] : 0});
                    guest_stations.append({'stationobj': obj});
                    guestgroup_added(item);

                    guest_station_map[item] = obj;
            }
        }

        //Now remove all old groups that we're no longer part of
        for (var key in allgroups){
            if(key == undefined) continue;

            console.log("Remove:", key, allgroups[key] );
            var lobj = guest_stations.get(allgroups[key]);
            guest_stations.remove(allgroups[key]);
            try{
                lobj.stationobj.destroy();
            }
            catch(exception) {
            }
        }
    }

    onDataChanged: {
        update_groups(data);
    }

    onPending_invitesChanged: {
        pending_invites.forEach(function(inviteobj){
            guest_pending_invites.append(inviteobj);
        });
    }
}
