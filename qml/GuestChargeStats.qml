import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Flickable {   
    interactive: true;
    boundsMovement: Flickable.StopAtBounds
    contentWidth: parent.width;
    contentHeight: content.implicitHeight + content.anchors.margins * 2;
    anchors.fill: parent;
    anchors.margins: 15;

    clip: true;

    property double power;
    property double orderstart;
    property double orderstop;
    property double consumption;
    property string orderno: '-';

    property double price;
    property double unitprice;
    property string valuta;

    property int poll_interval: 5*1000;

    function updateValues(ok, orderinfo){
        if(!ok) return;

        try{
            orderstart = orderinfo.Started;
        }
        catch(exception1) {
            return; //Nothing to show yet
        }

        try{
            consumption = orderinfo.consumption;
            power = orderinfo.power;
        }
        catch(exception1) {
        }      

        orderno = orderinfo.orderid ?? '-';

        if ('order' in orderinfo){
            unitprice = orderinfo.order.price/consumption;
            price = orderinfo.order.price;
            valuta = orderinfo.order.valuta;
        }
        else{
            unitprice = 0.0;
            price = 0.0;
            valuta = "DKK";
        }

        if("Ended" in orderinfo){
            charging = false;
            orderstop = orderinfo.Ended;
            guestcharge_stopped();
            poll_interval = 5*1000;
        }
        else{
            guestcharge_started();
            poll_interval = 20*1000;
        }
    }

    ColumnLayout{
        id: content;
        width: parent.width;
        spacing: 30;

        GuestElabsed{
            Layout.fillHeight: false;
            Layout.fillWidth: true;
        }

        GuestConsumption{
            Layout.fillHeight: false;
            Layout.fillWidth: true;
        }
        GuestCost{
            Layout.fillHeight: false;
            Layout.fillWidth: true;
        }
        GuestOrder{
            Layout.fillHeight: false;
            Layout.fillWidth: true;
        }
    }

    Timer{
        running: charging;
        interval: poll_interval;
        repeat: true;
        triggeredOnStart: false;
        onTriggered: lkinterface.guestcharge.requestOrderinfo(stationid, updateValues);
    }

    Component.onCompleted: {
        lkinterface.guestcharge.requestOrderinfo(stationid, updateValues);
        charging = true;
    }

    Item{
        property bool trigger: charging;
        onTriggerChanged: {
            if(!charging && !orderstop){
                lkinterface.guestcharge.requestOrderinfo(stationid, updateValues);
            }
        }
    }
}
