import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Rectangle{
    id: button_unlock;

    function setButton(lock){
        if(lock < 0){
            butlbl.text = qsTr("WAIT");
            butlbl.color = "white";
            button_unlock.color = "red";
            button_unlock.enabled = false;
            causelbl.text = "";
            return;
        }
        else if(lock){
            butlbl.text = qsTr("LOCK");
            butlbl.color = lkpalette.base_extra_dark;
            button_unlock.color = lkpalette.base_white;

            if(readings.autoon){
                causelbl.text = qsTr("HAPPY HOUR");
            }
            if(readings.manon){
                causelbl.text = qsTr("MANUAL-ON");
            }
            if(readings.gueston){
                causelbl.text = qsTr("GUEST CHARGING");
            }
        }
        else{
            butlbl.text = qsTr("UNLOCK");
            butlbl.color = lkpalette.base_white;
            button_unlock.color = lkpalette.signalgreen;
            causelbl.text = "";
        }
        button_unlock.enabled = true;
    }

    property int relaystate: readings.autoon || readings.manon || readings.gueston;

    radius: 20;
    color: lkpalette.base;

    Component.onCompleted: {
        setButton(relaystate)
    }

    onRelaystateChanged: {
        setButton(relaystate)
    }

    Label{
        id: butlbl;
        anchors.centerIn: parent;
        font.pointSize: 20;
        font.bold: true;
    }
    Label{
        id: causelbl;
        anchors.left: parent.left;
        anchors.bottom: parent.bottom;
        anchors.margins: 5;
        font.pointSize: lkfont.sizeSmall;
        color: lkpalette.text;
    }

    MouseArea{
        anchors.fill: parent;

        onClicked: {
            if(button_unlock.relaystate){
                setButton(-1);
                http.put('/cp/' + stationid + '/stopcharge', '', function (o) {
                    if(o.readyState === XMLHttpRequest.DONE){
                        console.log("stopcharge", o.status);
                        var js
                        if(o.status === 200) {
                            readings.manon = 0;
                            readings.autoon = 0;
                        }
                        else if(o.status === 0) {
                            setButton(1);
                        }
                        else if(o.status === 429) {
                            js= JSON.parse(o.responseText);
                            console.log("Too many request, ready in", js.seconds_remaining)
                            setButton(1);
                        }
                        else{
                            setButton(1);
                            console.log("ERROR", o.status);
                        }
                    }

                });
            }
            else{
                setButton(-1);
                http.put('/cp/' + stationid + '/startmanuelcharge', '', function (o) {
                    if(o.readyState === XMLHttpRequest.DONE){
                        console.log("startcharge", o.status);
                        if(o.status === 200) {
                            readings.manon = 1;
                        }
                        else if(o.status === 0) {
                            setButton(0);
                        }
                        else if(o.status === 429) {
                            var js= JSON.parse(o.responseText);
                            console.log("Too many request, ready in", js.seconds_remaining)
                            setButton(0);
                        }
                        else{
                            console.log("ERROR", o.status);
                            setButton(0);
                        }
                    }
                });
            }
        }
    }
}
