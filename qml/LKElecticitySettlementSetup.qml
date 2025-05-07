import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Item {
    ListModel{
        id: spotpriceareahistory;
    }

    ListModel{
        id: netcompanyhistory;
    }

    ListModel{
        id: subscriptionhistory;
    }

    ListModel{
        id: stored_fixed_settlements;
    }

    ListModel{
        id: stored_variable_settlements;
    }

    ListModel{
        id: stored_tax_reduction_settlements;
    }

    Column{
        anchors.margins: 5;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: parent.top;
        ColumnLayout{
            spacing: 5;
            width: parent.width;
            LKLabel{
                text: qsTr("Netcompany") + ":";
            }
            LKLabel{
                text: netcompanyhistory.count > 0 ? netcompanyhistory.get(0)["Selsk_Nvn"] : qsTr("Place station to see data");
                Layout.alignment: Qt.AlignRight;
            }
            Item{
                Layout.fillWidth: true;
                LKSeperator{}
            }
        }
        ColumnLayout{
            spacing: 5;
            width: parent.width;
            LKLabel{
                text: qsTr("Spotprice Area") + ":";
            }
            LKLabel{
                text: spotpriceareahistory.count > 0 ? spotpriceareahistory.get(0)["area"] : qsTr("Place station to see data");
                Layout.alignment: Qt.AlignRight;
            }
            Item{
                Layout.fillWidth: true;
                LKSeperator{}
            }
        }
        MouseArea{
            width: parent.width;
            height: subhistcol.height;
            onClicked: {
                activestack.push(subscriptionedit);
            }

            ColumnLayout{
                id: subhistcol;
                spacing: 5;
                width: parent.width;
                LKLabel{
                    text: qsTr("Electricity settlement") + ":";
                }
                LKLabel{
                    id: active_settlement;
                    Layout.alignment: Qt.AlignRight;
                }
                Item{
                    Layout.fillWidth: true;
                    LKSeperator{}
                }
            }
        }
        MouseArea{
            width: parent.width;
            height: taxhistcol.height;
            onClicked: {
                activestack.push(taxhistoryedit);
            }

            ColumnLayout{
                id: taxhistcol;
                spacing: 5;
                width: parent.width;
                LKLabel{
                    text: qsTr("Tax reduction settlement") + ":";
                }
                LKLabel{
                    id: active_taxation_settlement;
                    Layout.alignment: Qt.AlignRight;
                }
                Item{
                    Layout.fillWidth: true;
                    LKSeperator{}
                }        }
        }
    }
    ColumnLayout{
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.margins: 5;
        spacing: 20

        LKMenuItem{
            height: 75;
            width: parent.width;
            icon: "\uE825"
            text: qsTr("New Electricity settlement");
            onClicked: {
                activestack.push(new_or_old_picker);
            }
        }
        LKMenuItem{
            height: 75;
            width: parent.width;
            icon: "\uE825"
            text: qsTr("New Tax reduction agreement");
            onClicked: {
                activestack.push(tax_reduction);
            }
        }
    }


    Component{
        id: new_or_old_picker;
        Item{
            LKStackView{
                anchors.fill: parent;
                anchors.margins: 5;

                property string headertext: qsTr("ADD SETTLEMENT");
                initialItem: Item{
                    ColumnLayout{
                        width: parent.width;
                        spacing: 20;
                        Item{
                            Layout.fillWidth: true;
                            Layout.preferredHeight: 50;

                            LKSeperator{
                                anchors.left: parent.left;
                                anchors.right: parent.right;
                                anchors.bottom: parent.bottom;
                                width: parent.width;
                            }

                            LKMenuItem{
                                anchors.fill: parent;
                                text: qsTr("Create a new settlement");
                                icon: "\uE816";
                                onClicked: activestack.push(create_new_settlement);
                            }
                        }
                        Item{
                            Layout.fillWidth: true;
                            Layout.preferredHeight: 50;

                            LKSeperator{
                                anchors.left: parent.left;
                                anchors.right: parent.right;
                                anchors.bottom: parent.bottom;
                                width: parent.width;
                            }

                            LKMenuItem{
                                anchors.fill: parent;
                                text: qsTr("Use a stored settlement");
                                icon: "\uE816";
                                onClicked: activestack.push(stored_settlement_picker);
                            }
                        }
                    }
                }
            }
        }
    }

    function set_user_stored_settlement_cb(ok, retval){
        if(!ok) return;
        lkinterface.electricitySettlement.request_electricity_settlement(activeCharger.id, request_electricity_settlement_cb);
    }

    Component{
        id: stored_settlement_picker;
        LKElectricityStoredPicker{
            function done_picking(date){
                var day = date.getDate();
                var month = date.getMonth();
                var year = date.getFullYear()
                var d = new Date(year, month, day);
                d = d.getTime();

                lkinterface.electricitySettlement.set_user_stored_settlement(activeCharger.id, d, picked, set_user_stored_settlement_cb);
                activestack.setLastActiveStack();
            }

            onDone:{
                activestack.push(active_from_date, {"done_ptr": done_picking});
            }
        }
    }

    function req_add_new_settlement_cb(ok, retval){
        if(!ok) return;
        lkinterface.electricitySettlement.request_electricity_settlement(activeCharger.id, request_electricity_settlement_cb);
    }

    Component{
        id: create_new_settlement;
        LKCreateESettlement{
            function done_picking(date){
                var day = date.getDate();
                var month = date.getMonth();
                var year = date.getFullYear()
                var d = new Date(year, month, day);
                d = d.getTime();

                lkinterface.electricitySettlement.req_add_new_settlement(activeCharger.id, d, settlement_type_fixed, name, settlement_tariff, req_add_new_settlement_cb);
                activestack.setLastActiveStack();
            }

            onDone:{
                activestack.push(active_from_date, {"done_ptr": done_picking});
            }
        }
    }

    function add_electricity_tax_settlement_cb(ok, retval){
        if(!ok) return;
        lkinterface.electricitySettlement.get_electricity_tax_settlements(activeCharger.id, get_electricity_tax_settlements_cb);
    }

    Component{
        id: tax_reduction;
        Item{
            LKStackView{
                anchors.fill: parent;
                anchors.margins: 5;
                property string headertext: qsTr("TAX REDUCTION MODE");
                initialItem: LKElectricityTaxReductionSettlement{
                    function done_picking(date){
                        var day = date.getDate();
                        var month = date.getMonth();
                        var year = date.getFullYear()
                        var d = new Date(year, month, day);
                        d = d.getTime();

                        lkinterface.electricitySettlement.add_electricity_tax_settlement(activeCharger.id, d, tax_reduction_on, tax_reduction_by_ladeklubben, add_electricity_tax_settlement_cb);
                        activestack.setLastActiveStack();
                    }

                    onDone:{
                        activestack.push(active_from_date, {"done_ptr": done_picking});
                    }
                }
            }
        }
    }



    /* Widgets */
    Component{
        id: active_from_date;
        Item{
            id: first;
            property var done_ptr;
            signal done()
            LKDatePicker {
                id: dp;
                anchors.bottom: buttons.top;
                anchors.top: parent.top;
                anchors.left: parent.left;
                anchors.right: parent.right;
            }
            LKButtonRowNextHelp{
                id: buttons;
                anchors.bottom: parent.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;

                function next_page(){
                    done_ptr(dp.date);
                }
                next: next_page;
                help: qsTr("Set when this settlement will be active from. It will continue to be used until another settlement starts");
            }
        }
    }

    /****************************/
    Component{
        id: subscriptionedit;
        Item{
            LKStackView{
                property string headertext: qsTr("SUBSCRIPTION HISTORY");
                anchors.fill: parent;
                anchors.margins: 5;

                initialItem: subscription_history_list;

                Component{
                    id: subscription_history_list
                    LKListview{
                        id: lw;
                        anchors.fill: parent;
                        model: subscriptionhistory;
                        spacing: 30;
                        delegate: Item{
                            height: si.height;
                            width: lw.width;
                            Column{
                                id: si;
                                spacing: 10;
                                LKLabel{
                                    text: datetime.format_date(propData.from) + " - " + (propData.to === -1 ? ">" : datetime.format_date(propData.to));
                                    font.pointSize: lkfont.sizeNormal;
                                    Rectangle{
                                        anchors.bottom: parent.bottom;
                                        height: 1;
                                        width: parent.width;
                                        color: propData.active === true ? lkpalette.signalgreen : "transparent";
                                    }
                                }

                                LKLabel{
                                    text: propData.name;
                                    font.italic: true;
                                }
                                Row{
                                    spacing: 30;
                                    Row{
                                        spacing: 5;
                                        LKLabel{
                                            text: qsTr("Tariff") + ":";
                                            font.pointSize: 10;
                                        }
                                        LKLabel{
                                            text: Number(propData.tariff).toLocaleString(Qt.locale(), 'f', 2);
                                            font.pointSize: 10;
                                        }
                                        LKLabel{
                                            text: "DKK/kWh";
                                            font.pointSize: 10;
                                        }
                                    }
                                    Row{
                                        spacing: 5;
                                        LKLabel{
                                            text: qsTr("Type") + ":";
                                            font.pointSize: 10;
                                        }
                                        LKLabel{
                                            text: propData.type;
                                            font.pointSize: 10;
                                        }
                                    }
                                }
                            }
                            LKSeperator{

                            }
                        }
                        onItem_clicked: function(index){
                            console.log("Edit", index);
                        }

                        function delete_settlement_ref_cb(ok, retval){
                            if(!ok) return;
                            lkinterface.electricitySettlement.request_electricity_settlement(activeCharger.id, request_electricity_settlement_cb);
                        }

                        onRemove: function(index){
                            lkinterface.electricitySettlement.delete_settlement_ref(activeCharger.id, subscriptionhistory.get(index).from, delete_settlement_ref_cb)
                        }
                    }
                }
            }
        }
    }


    Component{
        id: taxhistoryedit
        Item{
            function tax_reduction_string(enabled, lk_handled){
                if(!enabled) return qsTr("Tax included");
                if(lk_handled) return qsTr("Ladeklubben will request tax return");
                return qsTr("No Tax, but its handled outside Ladeklubben");
            }
            LKStackView{
                property string headertext: qsTr("TAX REDUCTION HISTORY");
                anchors.fill: parent;
                anchors.margins: 5;

                initialItem: LKListview{
                    id: lw;
                    spacing: 30;
                    model: stored_tax_reduction_settlements;
                    delegate: Item{
                        height: subscription_item.height;
                        width: lw.width;
                        Column{
                            id: subscription_item;
                            spacing: 10;
                            LKLabel{
                                text: datetime.format_date(propData.from) + " - " + (propData.to === -1 ? ">" : datetime.format_date(propData.to));
                                font.pointSize: lkfont.sizeNormal;
                                Rectangle{
                                    anchors.bottom: parent.bottom;
                                    height: 1;
                                    width: parent.width;
                                    color: propData.active === true ? lkpalette.signalgreen : "transparent";
                                }
                            }
                            LKLabel{
                                text: tax_reduction_string(propData.enabled, propData.lk_handled);
                                font.pointSize: lkfont.sizeSmall;
                            }
                        }
                    }
                    onItem_clicked: {
                        //console.log("Edit", index);
                    }

                    function delete_tax_reduction_settlement_cb(ok, retval){
                        if(!ok) return;
                        var s = retval;

                        lkinterface.electricitySettlement.get_electricity_tax_settlements(activeCharger.id, get_electricity_tax_settlements_cb);
                    }

                    onRemove:function(index){
                        lkinterface.electricitySettlement.delete_tax_reduction_settlement(activeCharger.id, stored_tax_reduction_settlements.get(index).from, delete_tax_reduction_settlement_cb)
                    }
                }
            }
        }
    }

    function req_electricity_constants_cb(ok, retval){
        if(!ok) return;

        var s = retval;

        netcompanyhistory.clear();
        spotpriceareahistory.clear();

        var nc = s.netcompany;
        nc.reverse().forEach(function(entry){
            var d = entry[0];
            d['timestamp'] = entry[1];
            netcompanyhistory.append(d);
        });

        var sa = s.spotpriceArea;
        sa.reverse().forEach(function(entry){
            var d = {
                'area': entry[0],
                'timestamp': entry[1]
            }
            spotpriceareahistory.append(d);
        });
    }

    function request_electricity_settlement_cb(ok, retval){
        if(!ok) return;

        var ss = retval;
        subscriptionhistory.clear();

        var active = add_to_model(ss, subscriptionhistory);
        active_settlement.text =  active !== undefined ? active["name"] : qsTr("No active settlement");
    }

    function req_member_stored_settlements_cb(ok, retval){
        if(!ok) return;
        let s = retval;
        stored_fixed_settlements.clear();
        stored_variable_settlements.clear();
        s.forEach(function(entry){
            entry.tariff = entry.tariff * 1.25;
            if(entry.type === "fixed"){
                stored_fixed_settlements.append(entry);
            }
            else{
                stored_variable_settlements.append(entry);
            }
        });
    }

    function add_to_model(datalist, model){
        if(!datalist.length) return;

        /*
            datalist is always arranged as:
                [{dictionary with properties}, <from epoch time>,
]                {},<>,
                ...]
        */
        var active;
        for(var i=0; i<datalist.length; i++){
            var d = datalist[i][0];
            d['from'] = parseInt(datalist[i][1]);
            if(i < datalist.length -1){
                d['to'] = parseInt(datalist[i+1][1]);
                d['active'] = d['to'] >= datetime.start_today_epoch ? true : false;
            }
            else{
                d['to'] = -1;
                if(d['from'] <= datetime.start_today_epoch){
                    d['active'] = true;
                }
            }
            d['tariff'] *= 1.25;
            //Insert so that newest is on top
            model.insert(0, d);

            if(d['active'] === true) active = d;
        }
        return active;
    }

    function get_electricity_tax_settlements_cb(ok, retval){
        if(!ok) return;
        var s = retval;
        stored_tax_reduction_settlements.clear();
        var active = add_to_model(s, stored_tax_reduction_settlements);
        active_taxation_settlement.text = active !== undefined ? qsTr("Active") : qsTr("No active settlement");
    }


    Component.onCompleted: {
        lkinterface.electricitySettlement.request_electricity_constants(activeCharger.id, req_electricity_constants_cb);
        lkinterface.electricitySettlement.request_electricity_settlement(activeCharger.id, request_electricity_settlement_cb);
        lkinterface.electricitySettlement.request_member_stored_settlements(req_member_stored_settlements_cb);
        lkinterface.electricitySettlement.get_electricity_tax_settlements(activeCharger.id, get_electricity_tax_settlements_cb);
        header.headText = qsTr("ELECTRICITY SETTLEMENT")
    }
}
