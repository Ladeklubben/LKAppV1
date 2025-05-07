import QtQuick 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item{
    signal daysChanged();

    property bool accepted: false;

    function set_day_active(day){
        dayentry.setProperty(day, "active", true);
    }

    function get_days_active(){
        var d = [];
        for(let i=0; i<dayentry.count; i++){
            if(dayentry.get(i).active){
                d.push(i);
            }
        }
        return d;
    }

    ListModel{
        id: dayentry;
        ListElement{ day: qsTr("Mon"); active: false}
        ListElement{ day: qsTr("Tue"); active: false}
        ListElement{ day: qsTr("Wen"); active: false}
        ListElement{ day: qsTr("Thu"); active: false}
        ListElement{ day: qsTr("Fri"); active: false}
        ListElement{ day: qsTr("Sat"); active: false}
        ListElement{ day: qsTr("Sun"); active: false}
    }

    Row{
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        height: 50;
        Repeater{
            model: dayentry;
            delegate: Rectangle{
                color: active ? lkpalette.signalgreen : lkpalette.base_grey;

                height: parent.height;
                width: parent.width/7;
                Label{
                    anchors.centerIn: parent;
                    text: day;
                    color: "white";
                    font.pointSize: 12;
                }
                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        dayentry.setProperty(index, 'active', !dayentry.get(index).active)

                        for(let i=0; i<dayentry.count; i++){
                            if(dayentry.get(i).active){
                                accepted = true;
                                daysChanged();
                                return;
                            }
                        }
                        accepted = false;
                    }
                }
            }
        }
    }
}

