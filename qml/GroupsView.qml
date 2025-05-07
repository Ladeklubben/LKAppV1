import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtQuick 2.12


Rectangle{
    color: lkpalette.g_page_bg;

    property int group_discount: 1;
    property int group_free: 2;
    property int group_flat: 3;

    LKStackView {
        id: groupsstack;
        anchors.fill: parent;
        anchors.topMargin: 20;
        initialItem: groupsoverview;


        ColumnLayout{
            id: groupsoverview
            property string headertext: qsTr("GROUPS");
            property string headersubtext: "";

            width: parent.width;
            height: parent.height;
            spacing: 23;
            Item{
                id: groups_shortcuts;
                height: 40;
                Layout.fillHeight: false;
                Layout.fillWidth: true;
                GridLayout{
                    anchors.fill: parent;
                    columns: 3
                    columnSpacing: 20;
                    LKButton{
                        text: qsTr("FREE");
                        Layout.preferredWidth: parent.width / 3
                        Layout.fillWidth: true;
                        Layout.fillHeight: true;
                        onClicked: gsw.currentIndex = 0;
                        color: gsw.currentIndex == 0 ? lkpalette.g_free : lkpalette.g_button_bg;
                        bordercolor: color;
                        textcoler: gsw.currentIndex == 0 ? lkpalette.g_button_bg : lkpalette.base;
                        button_radius: 20
                        bold: gsw.currentIndex == 0 ? true : false;
                        pointsize: 14;
                    }
                    LKButton{
                        text: qsTr("DISCOUNT");
                        Layout.preferredWidth: parent.width / 3
                        Layout.fillWidth: true;
                        Layout.fillHeight: true;
                        onClicked: gsw.currentIndex = 1;
                        color: gsw.currentIndex == 1 ? lkpalette.g_discount : lkpalette.g_button_bg;
                        bordercolor: color;
                        textcoler: gsw.currentIndex == 1 ? lkpalette.g_button_bg : lkpalette.base;
                        button_radius: 20
                        bold: gsw.currentIndex == 1 ? true : false;
                        pointsize: 14;
                    }
                    LKButton{
                        text: qsTr("FLAT");
                        Layout.preferredWidth: parent.width / 3
                        Layout.fillWidth: true;
                        Layout.fillHeight: true;
                        onClicked: gsw.currentIndex = 2;
                        color: gsw.currentIndex == 2 ? lkpalette.g_flat : lkpalette.g_button_bg;
                        bordercolor: color;
                        textcoler: gsw.currentIndex == 2 ? lkpalette.g_button_bg : lkpalette.base;
                        button_radius: 20
                        bold: gsw.currentIndex == 2 ? true : false;
                        pointsize: 14;
                    }
                }
            }

            SwipeView {
                id: gsw;
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                currentIndex: 1;
                interactive: false;

                GroupList{
                    id:gl_free;
                    Layout.fillWidth: true;
                    but_plus_color: lkpalette.g_free;
                    but_minus_color: lkpalette.buttonDown;

                    model: ownergroups.free
                    delegate: LKGroupEntry{
                        width: gsw.width;
                        groupobj: obj;
                        groupcolor: g_color;
                        memberscount: members;
                        tarif: RowLayout
                            {
                                Label{
                                    text: qsTr("Tarif") + ":"
                                    color: groupcolor;
                                    font.bold: true;
                                }
                                Label{
                                    text: qsTr("Chargins will be free for members")
                                    color: groupcolor;
                                    font.bold: true;
                                }
                            }
                        onClicked: {                        
                            groupsstack.push(edit_group, {
                                                 "groupobj": obj,
                                                 "groupid": group_free,
                                                 "headersubtext": qsTr("FREE") + " - " + obj.info.title,
                                                 'groupcolor': g_color,
                                                 'parent_model': ownergroups.free,
                                                 'model_idx': index});
                        }
                        onSettings_clicked:{
                            groupsstack.push(create_group_free, {'groupobj': obj});
                        }

                        onMovementStarted: gl_free.interactive = false;
                        onMovementEnded: gl_free.interactive = true;
                        onRemove: ownergroups.remove_group(group_free, obj.info.title);
                    }
                    onCreateNewEvent:{
                        groupsstack.push(create_group_free);
                    }
                }

                GroupList{
                    id: gldiscount
                    spacing: 15;
                    but_plus_color: lkpalette.g_discount;
                    but_minus_color: lkpalette.buttonDown;

                    model: ownergroups.discount;
                    delegate: LKGroupEntry{
                        width: gsw.width;
                        groupobj: obj;
                        groupcolor: g_color;
                        memberscount: members;
                        tarif: RowLayout {
                            Label{
                                text: qsTr("Rabat tariff") + ":"
                                color: groupcolor;
                                font.bold: true;
                            }
                            Label{
                                text: groupobj.info.tariff === undefined ? '' : groupobj.info.tariff;
                                color: groupcolor;
                                font.bold: true;
                            }
                            Label{
                                text: '%';
                                color: groupcolor;
                                font.bold: true;
                            }
                        }
                        onClicked: {
                            groupsstack.push(edit_group, {
                                                 "groupobj": obj,
                                                 "groupid": group_discount,
                                                 "headersubtext": qsTr("DISCOUNT") + " - " + obj.info.title,
                                                 'groupcolor': g_color,
                                                 'parent_model': ownergroups.discount,
                                                 'model_idx': index});

                        }
                        onSettings_clicked:{
                            groupsstack.push(create_group_discount, {'groupobj': obj});
                        }
                        onMovementStarted: gldiscount.interactive = false;
                        onMovementEnded: gldiscount.interactive = true;
                        onRemove: ownergroups.remove_group(group_discount, obj.info.title);
                    }

                    onCreateNewEvent:{
                        groupsstack.push(create_group_discount);
                    }
                }

                GroupList{
                    id: glflat;
                    Layout.fillWidth: true;
                    but_plus_color: lkpalette.g_flat;
                    but_minus_color: lkpalette.buttonDown;

                    model: ownergroups.flat;
                    delegate: LKGroupEntry{
                        width: gsw.width;
                        groupobj: obj;
                        groupcolor: g_color;
                        memberscount: members;
                        tarif: RowLayout
                            {
                                Label{
                                    text: qsTr("Tarif") + ":"
                                    color: groupcolor;
                                    font.bold: true;
                                }
                                Label{
                                    text: groupobj.info.tariff === undefined ? '' : groupobj.info.tariff;
                                    color: groupcolor;
                                    font.bold: true;
                                }
                                Label{
                                    text: 'DKK';
                                    color: groupcolor;
                                    font.bold: true;
                                }
                            }
                        onClicked: {
                            groupsstack.push(edit_group, {
                                                 "groupobj": obj,
                                                 "groupid": group_flat,
                                                 "headersubtext": qsTr("FLAT")  + " - " + obj.info.title,
                                                 'groupcolor': g_color,
                                                'parent_model': ownergroups.flat,
                                                'model_idx': index});
                        }
                        onSettings_clicked:{
                            groupsstack.push(create_group_flat, {'groupobj': obj});
                        }
                        onMovementStarted: glflat.interactive = false;
                        onMovementEnded: glflat.interactive = true;
                        onRemove: ownergroups.remove_group(group_flat, obj.info.title);
                    }
                    onCreateNewEvent:{
                        groupsstack.push(create_group_flat);
                    }
                }
            }
        }

        Component{
            id: create_group_free;
            GroupCreate{
                groupid: group_free;
                property string headersubtext: qsTr("FREE");
            }
        }

        Component{
            id: create_group_discount;
            GroupCreate{
                groupid: group_discount;
                property string headersubtext: qsTr("DISCOUNT");
                tariff_component: LKTariffEdit{
                    unit: "%";
                }
            }
        }

        Component{
            id: create_group_flat;
            GroupCreate{
                groupid: group_flat;
                property string headersubtext: qsTr("FLAT");

                tariff_component: LKTariffEdit{
                    unit: "DKK";
                    maximumLength: 6;
                    tariff_validator: DoubleValidator{
                        decimals: 2;
                        top: 5000;
                    }
                }
            }
        }



        Component{
            id: edit_group;
            LKGroupEdit{
                property string headertext: qsTr("EDIT GROUP");
                property string headersubtext: "";
            }
        }
    }
}
