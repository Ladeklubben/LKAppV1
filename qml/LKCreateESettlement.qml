import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Item{
    signal done();

    property bool settlement_type_fixed: false;
    property double settlement_tariff: 1.0;
    property string name;

    LKMultiPicker{
        id: type_multi_picker;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: submit_settlement_type_button.top;
        anchors.margins: 5;

        multiselect: false;
        items: ListModel{
            id: list_of_types;
            Component.onCompleted: {
                append({"name": qsTr("Fixed price"), "selected": settlement_type_fixed});
                append({"name": qsTr("Variable price"), "selected": !settlement_type_fixed});
            }
        }
    }
    LKButtonRowNextHelp{
        id: submit_settlement_type_button;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        enabled: type_multi_picker.selected_count > 0;
        function next_page(){
            settlement_type_fixed = list_of_types.get(0).selected;
            if(settlement_type_fixed){
                activestack.push(set_fixed_tariff);
            }
            else{
                activestack.push(set_variable_tariff);
            }
        }
        next: next_page;
        help: qsTr("A fixed tariff is when the system calculates the electricity cost without taking spotprices in account. All other tariffs will still be added. Variable, will instead calculate according to actual spotprices");
    }



    Component{
        id: set_fixed_tariff;
        Item{
            Column{
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.margins: 5;

                spacing: 5;
                RowLayout{
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 50;
                    spacing: 5;

                    RowLayout{
                        id: lineinfo;
                        Layout.fillWidth: false;
                        Layout.fillHeight: true;
                        spacing: 10;
                        LKLabel{
                            text: qsTr("Fixed tariff") + ":";
                        }
                        LKHelp{
                            helpertext: qsTr("Add the amount that you are set to pay for each kWh consumed.");
                            Layout.fillHeight: true;
                            Layout.preferredWidth: 30;

                            onClicked: {
                                alertbox.setSource("LKAlertBox.qml", {"message": helpertext});
                            }
                        }
                    }

                    RowLayout{
                        Layout.fillWidth: true;
                        Layout.fillHeight: true;

                        Item{   //Just a fillup item
                            Layout.fillWidth: true;
                        }
                        LKValutaInput{
                            Layout.fillWidth: true;
                            Layout.maximumWidth: 100;
                            horizontalAlignment: TextInput.AlignHCenter;
                            id: pricetag;
                            Component.onCompleted: {
                                setFromNumericValue(settlement_tariff);
                            }


                        }
                        LKLabel{
                            id: valuta;
                            Layout.fillWidth: false;
                            text: "DKK/kWh";
                            leftPadding: 5;
                        }
                    }
                }
            }
            LKButtonRowNextHelp{
                anchors.bottom: parent.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                enable_next: pricetag.acceptableInput;
                function next_page(){
                    settlement_tariff = pricetag.getNumericValue();
                    activestack.push(settlement_naming);
                }
                next: next_page;
                help: qsTr("The fixed price tariff, is what you pay your electricity company for one kWh.")
            }
        }
    }

    Component{
        id: set_variable_tariff;
        Item{
            Column{
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.margins: 5;

                spacing: 5;
                RowLayout{
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 50;

                    RowLayout{
                        id: lineinfo;
                        Layout.fillWidth: false;
                        Layout.fillHeight: true;
                        spacing: 10;
                        LKLabel{
                            text: qsTr("Variable supplement") + ":";
                        }
                        LKHelp{
                            helpertext: qsTr("The price supplement is what is added to the spotprice for each kWh.");
                            Layout.fillHeight: true;
                            Layout.preferredWidth: 30;
                            Layout.maximumWidth: 70;

                            onClicked: {
                                alertbox.setSource("LKAlertBox.qml", {"message": helpertext});
                            }
                        }
                    }

                    RowLayout{
                        Layout.fillWidth: true;
                        Layout.fillHeight: true;

                        Item{   //Just a fillup item
                            Layout.fillWidth: true;
                        }
                        LKValutaInput{
                            Layout.fillWidth: true;
                            Layout.maximumWidth: 100;
                            horizontalAlignment: TextInput.AlignHCenter;
                            id: pricetag;
                            Component.onCompleted: {
                                setFromNumericValue(settlement_tariff);
                            }
                        }
                        LKLabel{
                            id: valuta;
                            Layout.fillWidth: false;
                            text: "DKK/kWh";
                            leftPadding: 5;
                        }
                    }
                }
            }
            LKButtonRowNextHelp{
                anchors.bottom: parent.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                enable_next: pricetag.acceptableInput;
                function next_page(){
                    settlement_tariff = pricetag.getNumericValue();
                    activestack.push(settlement_naming);
                }
                next: next_page;
                help: qsTr("Some electricity companies add a extra supplement to the price for each kWh consumed.")
            }
        }
    }

    Component{
        id: settlement_naming;
        Item{
            ColumnLayout{
                anchors.margins: 5;

                spacing: 20;
                anchors.left: parent.left;
                anchors.right: parent.right;
                height: 100;
                RowLayout{
                    spacing: 10;
                    Layout.fillWidth: false;
                    Layout.fillHeight: false;
                    LKLabel{
                        text: qsTr("Identifier (name)") + ":";
                        Layout.fillHeight: true;
                        Layout.alignment: Qt.AlignVCenter;
                    }
                    LKHelp{
                        helpertext: qsTr("Give this settlement a name. It is only used so that you can remember what this settlement is used for");
                        Layout.minimumWidth: 30;
                        Layout.fillHeight: true;
                        Layout.alignment: Qt.AlignVCenter;
                        onClicked: {
                            alertbox.setSource("LKAlertBox.qml", {"message": helpertext});
                        }
                    }
                }
                LKTextEdit{
                    id: settlement_name;
                    Layout.fillWidth: true;
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter;
                    Layout.fillHeight: false;
                    Layout.preferredWidth: parent.width;
                    text: name;
                }
            }
            LKButtonRowNextHelp{
                anchors.bottom: parent.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                enable_next: settlement_name.text.length > 2;
                function next_page(){
                    name = settlement_name.text;
                    done();
                }
                next: next_page;
                help: qsTr("Name the settlement - it can be anything")
            }
        }
    }
}

