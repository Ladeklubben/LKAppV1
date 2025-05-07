import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Item{
    property int ispublic;

    function set_public(enable){
        http.put('/cp/' + stationid + "/public?enable=" + (enable === 1), '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    ispublic = enable;
                }
                else if(o.status === 0){
                    alertbox.setSource("LKAlertBox.qml", {"message": "Network error"});
                }
                else if(o.status === 403){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("This kind og charger cannot be made public")});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });

    }

    Component.onCompleted: {
        header.headText = qsTr("Opening Hours")
    }

    LKToggleSetting{
        id: open;
        text: qsTr("Open for public") + " ? :";
        anchors.top: parent.top;
        anchors.topMargin: 10;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.margins: 5;
        activated: ispublic;

        onActivatedChanged: {
            if(activated != ispublic){
                set_public(activated);
            }
        }
    }

    LKButton{
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: 100;
        text: qsTr("Opening times");
        onClicked: {
            activestack.push(schwid);
        }
    }

    Component{
            id: schwid;
        ScheduleWidget{
            // geturi: '/openhours'
            // edituri: '/openhours';
            schedule_interface: lkinterface.schedule_opening;

            schedule: readings.schedule_openhours;
            Component.onDestruction: {
                readings.schedule_openhours = schedule;
            }
        }
    }

}




