import QtQuick 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {



    function get_transactions(){

        http.request('/ta/' + stationid + '/list', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    let transaction = JSON.parse(o.responseText)
                    transaction.forEach(function(t){
                        let obj = {
                            'TID': t.Tid,
                            'START': datetime.format_time(t.Started * 1000),
                        }

                        obj['CONSUMPTION'] = (t.meter_stop - t.meter_start).toFixed(2) + ' ' + "kWh";

                        if('Ended' in t){
                            obj['ENDED'] = datetime.format_time(t.Ended * 1000);
                            obj['ELABSED'] = datetime.seconds_to_days_hours_mins_secs_str(t.Ended - t.Started);
                        }
                        else{
                            obj['ENDED'] = '-';
                            obj['ELABSED'] = '-';
                            //obj['CONSUMPTION'] = '-';
                        }
                        if('Cost' in t){
                            obj['COST'] = (1.25*t['Cost']).toFixed(2) + ' ' + "DKK";
                        }
                        else{
                            obj['COST'] = ''
                        }

                        transactionmodel.append(obj);
                    });
                }
                //                else if(o.status === 400){
                //                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Unknown error")});
                //                }
                //                else if(o.status === 403){
                //                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Group already exists - please rename")});
                //                }
                //                else if(o.status === 404){
                //                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Group number not known to the system")});
                //                }
                else if(o.status === 0){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });
    }

    ListModel{
        id: transactionmodel;
    }

    ListView{
        id: lw;
        anchors.fill: parent;
        clip: true;
        spacing: 10;
        model: transactionmodel;
        delegate:
            Rectangle{
            id: transactionitem
            height: !details.visible ? 50 : 80;
            width: lw.width;
            color: index % 2 == 0 ? lkpalette.base : lkpalette.base_dark;

            ColumnLayout{
                id: i;
                anchors.margins: 5;
                anchors.left: parent.left;
                anchors.right: parent.right;
                //Layout.fillHeight: true;
                height: parent.height;

                RowLayout{
                    id: transactionoverview;
                    height: parent.height;
                    Layout.fillWidth: true;
                    Layout.fillHeight: true;

                    spacing: 15;
                    Label{
                        text: START;
                        font.pointSize: 12;
                        color: "white";
                        Layout.fillWidth: false;
                    }
                    Label{
                        text: CONSUMPTION;
                        font.pointSize: 12;
                        color: "white";
                        horizontalAlignment: Qt.AlignRight;
                        Layout.fillWidth: true;
                    }
                    Label{
                        text: COST;
                        font.pointSize: 12;
                        color: "white";
                        horizontalAlignment: Qt.AlignRight;
                        Layout.fillWidth: true;
                    }
                }
                RowLayout{
                    id: details;
                    visible: false;
                    spacing: 10;

                    Row{
                        spacing: 5;
                        Label{
                            text: "ID:";
                            color: "white";
                            font.pointSize: 10;
                        }
                        Label{
                            text: TID;
                            color: "white";
                            font.pointSize: 10;
                        }
                    }

                    Row{
                        spacing: 5;
                        Label{
                            text: qsTr("Ended") + ":";
                            color: "white";
                            font.pointSize: 10;
                        }
                        Label{
                            text: ENDED;
                            color: "white";
                            font.pointSize: 10;
                        }
                    }

                    Row{
                        spacing: 5;
                        Label{
                            text: qsTr("Elapsed") + ":";
                            color: "white";
                            font.pointSize: 10;
                        }
                        Label{
                            text: ELABSED;
                            color: "white";
                            font.pointSize: 10;
                        }
                    }

                    LKIconButton{
                        id:ploticon;
                        Layout.fillWidth: true;
                        Layout.fillHeight: true;
                        text: "\uE818"
                        pointsize: lkfont.sizeNormal;
                        onClicked: {
                            activestack.push(plot, {'tid': TID});
                        }
                    }
                }
            }

            MouseArea{
                x: transactionoverview.x;
                y: transactionoverview.y;
                height: transactionoverview.height;
                width: transactionoverview.width;

                onClicked: {
                    details.visible = !details.visible;
                }
            }
        }
    }

    Component{
        id: plot;
        LKRotation{
            id: test;
            property int tid;
            rotitem: LKTransactionPlot{
                id: tplot;
                tid: test.tid;
            }
        }
    }

    Component.onCompleted: {
        get_transactions();
        header.headText = qsTr("TRANSACTIONS")
    }
}
