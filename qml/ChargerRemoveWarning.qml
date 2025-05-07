import QtQuick 2.0
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtLocation 5.14
import QtPositioning 5.14


MouseArea{
    property string message: qsTr("DELETE CHARGER!")  + "\n\n" + qsTr("You are about to delete this charger from your account. You will lose all your data which can't be undone!");
    property string stationid;

    function delete_callback(ok, retval){
        if(ok){
            const index = root.stations.findIndex(item => item.id === stationid);
            if (index > -1) {
                root.stations.splice(index, 1);
            }
            root.stationsCount = root.stations.length;
            if(root.stations.length > 0){
                activestack.clear();
                activestack = rootstack;
                activestack.clear();
                activestack.push(station_swipeview);
            }

            alertbox.source = "";
        }
    }

    Rectangle{
        anchors.fill: parent;
        color: lkpalette.base;
        opacity: 0.5;
    }

    Rectangle {
        width: parent.width * 0.9;
        height: parent.height * 0.5;
        anchors.centerIn: parent;

        color: lkpalette.base;
        border.color: lkpalette.border;
        border.width: 2;

        Text{
            anchors.fill: parent;
            anchors.margins: 15;
            text: message
            color: lkpalette.text;
            font.pointSize: 20;
            wrapMode: Text.WordWrap;
            horizontalAlignment: Text.AlignHCenter;
            verticalAlignment: Text.AlignVCenter;
            font.bold: true;
        }

        Rectangle{
            property int count: 5
            color: "red";
            width: parent.width / 2 - 15;
            height: 75;
            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.margins: 10;
            Text{
                anchors.fill: parent;
                anchors.margins: 5;
                wrapMode: Text.WordWrap;
                horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;
                text: parent.count > 0 ? (qsTr("Hit button") + "\n" + parent.count + "\n" + qsTr("more times to delete")) : qsTr("Deleting!");
                color: "white"
                font.pointSize: 12;
            }

            MouseArea{
               anchors.fill: parent;
               onClicked: {
                if(--parent.count <= 0){
                    aboutbut.visible = false;
                    enabled = false;
                    lkinterface.user.delete_charger(stationid, delete_callback);
                }
               }
            }
        }

        Rectangle{
            id: aboutbut;
            color: lkpalette.signalgreen;
            width: parent.width / 2 - 15;
            height: 75;
            anchors.bottom: parent.bottom;
            anchors.right: parent.right;
            anchors.margins: 10;
            Label{
                anchors.centerIn: parent;
                text: qsTr("Cancel")
                color: "white"
                font.pointSize: 16;
            }
            MouseArea{
               anchors.fill: parent;
               onClicked: {
                   alertbox.source = "";

               }
            }
        }
    }
}
