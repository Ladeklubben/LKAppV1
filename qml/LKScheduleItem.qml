import QtQuick 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item{
    id: si;
    property int start;
    property int interval;
    property var days;

    signal clicked();
    signal movementEnded();
    signal movementStarted();
    signal remove();

    anchors.margins: 20;

    Label{
        visible: flicker.contentX < 0;
        anchors.left: parent.left;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.leftMargin: 30;
        color: "red";
        text: qsTr("REMOVE");
        font.bold: true;
        font.pointSize: 16;
    }

    Flickable{
        id: flicker
        property real update_rdy: 0;
        flickableDirection: Flickable.HorizontalFlick;
        interactive: true;

        height: parent.height;
        width: parent.width;

        onMovementEnded: si.movementEnded();
        onMovementStarted: si.movementStarted();

        onContentXChanged: {
            if(contentX < -width/3 && !update_rdy){
                update_rdy = 1;
                si.remove();
            }
        }

        Rectangle{
            anchors.fill: parent;
            color: lkpalette.base_light;
            radius: 5;

            Label{
                id: entry;
                font.pointSize: 14;
                font.bold: false;
                color: "grey";
                anchors.top: parent.top;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.margins: 10;
                height: 30;
            }

            LKScheduleDayItem{
                id: dayswidget;
                anchors.margins: 10;
                anchors.top: entry.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                height: 50;
            }

            MouseArea{
                id: ma;
                anchors.fill: parent;
                onClicked: si.clicked();
            }

            Component.onCompleted: {
                var d = JSON.parse(days);

                var hour_from = parseInt(starttime / 60);
                var minute_from = parseInt(starttime - (hour_from * 60));

                let stoptime = starttime + interval;
                if(stoptime > 24*60){
                    stoptime -= 24*60;
                }

                var hour_to = parseInt(stoptime / 60);
                var minute_to = parseInt(stoptime - (hour_to * 60));

                hour_from = ("0" + hour_from).slice(-2);
                minute_from = ("0" + minute_from).slice(-2);

                hour_to = ("0" + hour_to).slice(-2);
                minute_to = ("0" + minute_to).slice(-2);

                entry.text =  hour_from + ":" + minute_from + " - " + hour_to + ":" + minute_to;

                for(let i=0; i<d.length; i++){
                    dayswidget.set_day_active(d[i]);
                }
            }
        }
    }
}
