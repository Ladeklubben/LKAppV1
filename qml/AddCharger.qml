import QtQuick 2.0
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtLocation 5.14
import QtPositioning 5.14

Item{
    signal cancel();
    signal done();

    property var newstation;

    function req_addStation(stationid, json){
         http.post('/pair/'+stationid, json, function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    var s = {
                        "id": stationid,
                        newstation,
                    };
                    stations.push(s);
                    done();
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

    SetChargerWidget{
        id: chargerwidget
        anchors.fill: parent;

        donewidget: RowLayout{
            width: parent.width;
            height: 100;
            anchors.bottom: parent.bottom;
            LKButton{
                text: qsTr("CANCEL");
                Layout.fillWidth: true;
                Layout.fillHeight: true;
                onClicked: cancel();
            }
            LKButton{
                text: qsTr("ADD");
                Layout.fillWidth: true;
                Layout.fillHeight: true;
                onClicked: {
                    newstation = {
                        location: {
                            latitude: chargerwidget.latitude,
                            longitude: chargerwidget.longitude,
                            brief: chargerwidget.brief,
                            address: chargerwidget.address,
                            city: chargerwidget.city,
                            zip: chargerwidget.zip,
                        },
                        type: {
                            model: chargerwidget.model,
                            brand: chargerwidget.brand,
                            power: chargerwidget.psize,
                            connector: chargerwidget.conntype,
                        },
                    };
                    var json = JSON.stringify(newstation);
                    req_addStation(chargerwidget.sid, json);
                }
            }
        }
    }
}
