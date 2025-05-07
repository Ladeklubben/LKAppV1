import QtQuick 2.13

Item{
    id: ssp;
    property var picked: undefined;
    property var date_from;

    signal done();

    Row{
        id: type_picker;
        width: parent.width;
        height: 50;

        MouseArea{
            height: parent.height;
            width: parent.width/2;

            LKLabel{
                anchors.centerIn: parent;
                text: qsTr("FIXED");
            }
            onClicked: {
                settlement_list_loader.sourceComponent = undefined;
                settlement_list_loader.settlement_model = stored_fixed_settlements;
                settlement_list_loader.sourceComponent = settlement_list;
                picked = undefined;
            }
            Rectangle{
                height: 2;
                width: parent.width;
                anchors.bottom: parent.bottom;
                color: settlement_list_loader.settlement_model ===  stored_fixed_settlements? lkpalette.signalgreen : "transparent";
            }
        }
        MouseArea{
            height: parent.height;
            width: parent.width/2;

            LKLabel{
                anchors.centerIn: parent;
                text: qsTr("VARIABLE");
            }
            onClicked: {
                settlement_list_loader.sourceComponent = undefined;
                settlement_list_loader.settlement_model = stored_variable_settlements;
                settlement_list_loader.sourceComponent = settlement_list;
                picked = undefined;
            }
            Rectangle{
                id: marker;
                height: 2;
                width: parent.width;
                anchors.bottom: parent.bottom;
                color: settlement_list_loader.settlement_model ===  stored_variable_settlements? lkpalette.signalgreen : "transparent";
            }

            Component.onCompleted: {
                settlement_list_loader.sourceComponent = undefined;
                settlement_list_loader.settlement_model = stored_variable_settlements;
                settlement_list_loader.sourceComponent = settlement_list;
                picked = undefined;
            }
        }
    }
    Loader{
        id: settlement_list_loader;
        anchors.top: type_picker.bottom;
        anchors.topMargin: 10;
        anchors.bottom: nb.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        property var settlement_model;
    }
    LKButtonRowNextHelp{
        id: nb;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        enable_next: picked !== undefined;

        function next_page(){
            //activestack.push(from_date);
            done();
        }
        next: next_page;
        help: qsTr("Chose one of the already created settlements");
    }

    Component.onCompleted: {
        if(stored_variable_settlements.count > 0){
            settlement_list_loader.settlement_model = stored_variable_settlements;
            settlement_list_loader.sourceComponent = settlement_list;
        }
    }

    Component{
        id: settlement_list;
        LKListview{
            id: ss;
            remove_enabled: true;
            model: settlement_model;
            spacing: 15;
            delegate: MouseArea{
                height: subscription_item.height + 10;
                width: ss.width;
                Column{
                    id: subscription_item;
                    anchors.centerIn: parent;
                    width: parent.width - 10;
                    spacing: 10;
                    LKLabel{
                        text: propData.name;
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
                    }
                }

                LKIconButton{
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.right: parent.right;
                    text: "\uE800"
                    height: parent.height;
                    width: parent.height;
                    pointsize: 30;

                    onClicked: {
                        picked = ss.model.get(index);
                        ss.currentIndex = index;
                        activestack.push(stored_settlement_edit, {
                                             "settlement_type_fixed": picked.type === "fixed" ? true : false,
                                             "settlement_tariff": picked.tariff,
                                             "name": picked.name,
                                             "hash": picked.hash,
                                         });
                    }
                }


                onClicked: {
                    picked = ss.model.get(index);
                    ss.currentIndex = index;
                }

                Component.onCompleted: {
                    ss.currentIndex = -1;
                }

            }
            highlight: Rectangle{
                color: "transparent";
                radius: 5;
                border.width: 2;
                border.color: lkpalette.signalgreen;
                z: 10;
            }

            function remove_member_stored_settlement_cb(ok, retval){
                if(!ok) return;
                lkinterface.electricitySettlement.request_member_stored_settlements(req_member_stored_settlements_cb);
                lkinterface.electricitySettlement.request_electricity_settlement(activeCharger.id, request_electricity_settlement_cb);
            }

            onRemove: {
                var i = index;
                index = -1;
                ss.currentIndex = -1;
                lkinterface.electricitySettlement.remove_member_stored_settlement(ss.model.get(i)['hash'], remove_member_stored_settlement_cb)
            }

            Component.onCompleted: {
                ss.currentIndex = -1;
            }
        }
    }

    Component{
        id: stored_settlement_edit;
        LKStackView{
            id: sv;
            property bool settlement_type_fixed;
            property double settlement_tariff;
            property string name;
            property string hash;

            function update_stored_settlement_cb(ok, retval){
                if(!ok) return;
                lkinterface.electricitySettlement.request_member_stored_settlements(req_member_stored_settlements_cb);
                lkinterface.electricitySettlement.request_electricity_settlement(activeCharger.id, request_electricity_settlement_cb);
            }

            initialItem: LKCreateESettlement{
                settlement_type_fixed: sv.settlement_type_fixed;
                settlement_tariff: sv.settlement_tariff;
                name: sv.name;
                onDone:{
                    lkinterface.electricitySettlement.update_stored_settlement(hash, settlement_type_fixed, name, settlement_tariff, update_stored_settlement_cb);

                    settlement_list_loader.sourceComponent = undefined;
                    settlement_list_loader.sourceComponent = settlement_list;
                    picked = undefined;

                    activestack.setLastActiveStack();
                }
            }
        }
    }
}

