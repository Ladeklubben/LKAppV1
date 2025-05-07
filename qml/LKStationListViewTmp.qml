import QtQuick 2.13

//Should be changed with the LKStationListView, but as for now this is just a copy of an old version
ListView{
    id: lw;
    property var pickedStations: [];
    property bool something: false;

    function updateList(){
        chargeritems.clear();
        stations.forEach(function(station){
            let brief = "";
            if ('location' in station){
                if ('brief' in station.location){
                    brief = station.location.brief;
                }
            }

            chargeritems.append({"sid": station.id, "obj": station, "locbrief": brief, "mark": pickedStations.includes(station.id)});
        });
    }

    ListModel{
        id: chargeritems
    }

    spacing: 5;

    clip: true;
    model: chargeritems

    delegate: LKStationEntry{
        width: lw.width;
        textcolor: "black"
        stationid: sid;
        brief: locbrief;
        height: 100;
        markActive: mark;
        onClicked:{
            markActive = !markActive;
            if(markActive)
                pickedStations.push(stationid);
            else
                pickedStations.pop(stationid);
            lw.something = true;
        }
    }

    Component.onCompleted: {
        updateList();
        something = false;
    }
}
