import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Item {
    property var stationinfo;
    function getInfo(){
        request("/chargerinfo" + '/' + stationid, '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    var js = JSON.parse(o.responseText);
                    stationinfo = js.location;

                    positiongroup.clearView();
                    positiongroup.add({key: "Latitude:", value: stationinfo.latitude});
                    positiongroup.add({key: "Longitude:", value: stationinfo.longitude});

                    chargergroup.clearView();
                    chargergroup.add({key: "Type:", value: stationinfo.type})
                    chargergroup.add({key: "Plug:", value: stationinfo.plugtype})
                    chargergroup.add({key: "Power:", value: stationinfo.power})
                }
                else if(o.status === 0) {
                    //message = "Network error";
                    console.log(o.status)
                }
                else{

                }
            }
        });
    }

    Column{
        spacing: 5;
        anchors.fill: parent;
        anchors.margins: 5;

        LKGroupBox{
            id: chargergroup
            headline: "Charger information:"
        }
        LKGroupBox{
            id: positiongroup;
            headline: "Position:"
        }
    }

//    LKButton{
//        id: chargebutton;
//        property bool on: false
//        anchors.bottom: parent.bottom;
//        anchors.left: parent.left;
//        anchors.right: parent.right;
//        height: 100;
//        text: "Charge";

//        onClicked: {
//            if(on){
//                request('/stopcharge/' + stationid, function (o) {
//                    // log the json response
//                    console.log(o.responseText);

//                });
//                on = false;
//            }
//            else{
//                request('/startcharge/' + stationid, function (o) {
//                    // log the json response
//                    console.log(o.responseText);

//                });
//                on = true;
//            }
//        }
//    }

    Component.onCompleted: {
        //getInfo();

        positiongroup.clearView();
        positiongroup.add({key: "Latitude:", value: stationinfo.latitude});
        positiongroup.add({key: "Longitude:", value: stationinfo.longitude});

        chargergroup.clearView();
        chargergroup.add({key: "Type:", value: stationinfo.type})
        chargergroup.add({key: "Plug:", value: stationinfo.plugtype})
        chargergroup.add({key: "Power:", value: stationinfo.power})
    }
}



