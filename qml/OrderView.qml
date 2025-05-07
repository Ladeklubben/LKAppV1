import QtQuick 2.13
import QtQuick.Window 2.13
import QtQml 2.12
import QtQuick.Layouts 1.12

Flickable {
    interactive: true;
    boundsMovement: Flickable.StopAtBounds
    contentWidth: parent.width - anchors.margins * 2;
    contentHeight: content.implicitHeight + content.anchors.margins * 2;
    anchors.fill: parent;
    anchors.margins: 15;

    clip: true;

    property bool charging;
    property string stationid;
    property double power;
    property double orderstart;
    property double orderstop;
    property double consumption;
    property string orderno;

    property double price;
    property double unitprice;
    property string valuta;

    property int poll_interval: 5*1000;

    property var station_info;
    property var owner_info;
    property var payer_info;
    property var user_info;

    function updateValues(ok, orderinfo){
        if(!ok) return;

        try{
            orderstart = orderinfo.start;
            stationid = orderinfo.station;
            consumption = orderinfo.consumption;
        }
        catch(exception1) {
            return; //Nothing to show yet
        }

        if (consumption > 0)
        {
            unitprice = orderinfo.cost/consumption;
            price = orderinfo.cost;
            valuta = orderinfo.valuta;
        }
        else{
            unitprice = 0.0;
            price = 0.0;
            valuta = orderinfo.valuta;
        }

        if("stop" in orderinfo){
            charging = false;
            orderstop = orderinfo.stop;
            polltimer.stop();
        }
        else{
            power = orderinfo.power;
            charging = true;
        }

        station_info = orderinfo?.station_info ?? station_info;
        owner_info = orderinfo?.owner_info ?? owner_info;
        payer_info = orderinfo?.payer_info ?? payer_info;
        user_info = orderinfo?.user_info ?? user_info;
    }

    function handle_orderno(status, orderinfo){
        if(status){
            if(orderinfo && 'orderid' in orderinfo){
                orderno = orderinfo['orderid'];
                request_info();
            }
        }
        else{
            charging = false;
            polltimer.stop();
        }
        //Wait for timer to re-request orderid
    }

    function request_info(){
        if(orderno == ''){
            if(stationid == '') return;
            lkinterface.order.req_orderno(stationid, handle_orderno);
            return;
        }
        lkinterface.order.req_orderdetails(orderno, updateValues);
        // charging = false;
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
        id: polltimer;
        running: true;
        interval: parent.orderno == '' ? 1*1000 : 5*1000;
        repeat: true;
        triggeredOnStart: false;
        onTriggered: {
            parent.request_info();
        }
    }

    Component.onCompleted: {
        request_info();
    }
}
