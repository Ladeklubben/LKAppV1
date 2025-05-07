import QtQuick 2.13
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

ListView{
    id: lw;

    function add_station(i, stationobj){
        chargeritems.append({"idx": i, "obj": stationobj, "online": stationobj.isOnline});
    }

    ListModel{
        id: chargeritems
    }

    spacing: 20;
    clip: true;
    model: chargeritems

    delegate: LKMenuItem{
        height: 85
        width: ListView.view.width
        icon: "\u2630"
        icon_bk_color: online ? lkpalette.signalgreen : lkpalette.error;
        text: obj.stationid
        description: obj.stationinfo ===  undefined ? "" : obj.stationinfo.brief === undefined ? "" : obj.stationinfo.brief;
        onClicked:{
            change_station(idx);
        }
    }
}
