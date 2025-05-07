import QtQuick 2.14
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

/* Shows when the charger will be set on, or how far till it will be off */

MouseArea {
    id: neo;
    Rectangle{
        id: background;
        color: lkpalette.base_extra_dark;
        radius: 20;
        anchors.fill: parent;

        ColumnLayout{
            anchors.fill: parent;
            anchors.margins: 20;
            Label{
                id: info
                color: lkpalette.text;
                font.pointSize: lkfont.sizeNormal
                font.bold: true;
            }
            Label{
                id: to;
                color: lkpalette.text;
                font.pointSize: lkfont.sizeNormal
            }
        }
    }

    LKNextEventTimer{
        id: eventtimer;
        schedule: readings.schedule_openhours;

        onEventChanged: {
            if(event == event_none){
                neo.visible = false;
            }
            else if(event == event_start){
                neo.visible = true;
                info.text = qsTr("Closed until");
                to.text = event_time;
            }
            else if(event == event_end){
                neo.visible = true;
                info.text = qsTr("Open until");
                to.text = event_time;
            }
        }
    }
}
