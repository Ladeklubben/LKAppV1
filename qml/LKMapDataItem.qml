import QtQuick 2.13
import QtCharts 2.6

Item {
    property var obj;
    property string stationid;
    property var openhours;
    property var location;
    property string connector;
    property var listprice;
    property var energyprices;
    property LKMemberPriceSetup member_price;
    property real sellingprice;
    property real discount;

    property real lktarif: 1.1  //Ladeklubben charges 10% ontop for its service

    property var prices_ahead;

    property bool open: false;

    property var guest_group;

    signal destoying();

    onConnectorChanged:{
        if(active_charging_session == stationid){
            //Reset the active charging session, if the charger indicates available
            if(connector == "Available"){
                active_charging_session = '';
            }
        }
    }

    function update(info){
        obj = info;
    }

    function generate_fixed_pricelist(memberprice, discount){

        let price = memberprice + discount;
        price -= discount
        price *= lktarif;
        price *= 1.25;

        prices_ahead = {
            'Cost': new Array(24).fill(price),
            'start': datetime.epoch_start_hour((new Date().getTime())/1000),
        };
        sellingprice = price;
    }

    function generate_variable_pricelist(memberprice, discount, fallback){
        let epoch_hour = datetime.epoch_start_hour((new Date().getTime())/1000);
        let epoch_start = energyprices.start;

        var pl = new Array(24).fill(fallback*1.25);

        sellingprice = fallback*1.25;

        for(var i=0; i<energyprices.Costprice.length; i++){
            let price = energyprices.Costprice[i]/100;
            price += memberprice + discount;
            price -= discount
            price *= lktarif;
            price *= 1.25;
            let tidx = epoch_start + 3600*i;
            if(epoch_hour === tidx){
                sellingprice = price;
            }
            if(tidx >= epoch_hour)
                pl[i] = price;
        }
        prices_ahead = {
            'Cost': pl,
            'start': epoch_hour,
        };
    }

    function calculate_selling_price(){
        // console.log("******  *******", JSON.stringify(obj));
        // if(obj['stationid'] === "A10215111081"){
        //     console.log("Debug", JSON.stringify(obj));
        // }

        sellingprice = 0;
        discount = 0;
        if(listprice === null || member_price == null || listprice === undefined){
            return;
        }

        if(member_price.flat){
            generate_fixed_pricelist(0.0, 0.0);
            return;
        }
        if(member_price.free){
            generate_fixed_pricelist(0.0, 0.0);
            return;
        }

        // console.log("Listprice", JSON.stringify(listprice));
        // console.log("member_price", JSON.stringify(member_price.tariff_pct));

        var p = listprice.nominal * (1-member_price.tariff_pct/100);
        p = p < listprice.minimum ? listprice.minimum : p;  //0,4
        discount = (listprice.nominal - p);

        if(listprice.follow_spot === 1){
            if(energyprices === undefined){
                sellingprice = listprice.fallback;
                generate_fixed_pricelist(listprice.fallback, discount);
            }
            else{
                generate_variable_pricelist(p, discount, listprice.fallback);
            }
        }
        else{
            generate_fixed_pricelist(p, discount);
        }

        discount *= 1.25;
        // console.log("Discount", discount);
        // console.log("Energyprices", JSON.stringify(energyprices));
        // console.log("Listprice ahead:", JSON.stringify(prices_ahead));
        // console.log("sellingprice", sellingprice);
    }

    onMember_priceChanged: {
        calculate_selling_price();
    }
    onListpriceChanged: {
        calculate_selling_price();
    }

    onObjChanged: {
        openhours = obj.openhours;
        location = obj.location;
        connector = obj.connector;
        listprice = obj.prices;

        if ('energyprices' in obj){
            energyprices = obj.energyprices;
            //energyprice_ahead.clear();
            //energyprice_ahead.append(qsTr('Cost price'), energyprices['Costprice']);
        }
        calculate_selling_price();
    }

    Component.onCompleted: {
        stationid = obj.stationid;
    }


    LKNextEventTimer{
        schedule: openhours;

        onEventChanged: {
            if(event == event_start){
                open = false;
            }
            else if(event == event_end){
                open = true;
            }
        }
    }
}
