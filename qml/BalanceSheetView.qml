import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtQuick 2.12

Item {
    function get_balance_sheet(){
        http.request('/account/balance', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    var cl = JSON.parse(o.responseText);
                    balance_sheet_data.clear();
                    if(cl.length === 0){
                        balance_sheet.delegate = no_entry_item;
                        balance_sheet_data.append({"NA": "Nothing"});
                        return;
                    }
                    balance_sheet.delegate = balance_sheet_item;
                    cl.forEach(function(l){
                        balance_sheet_data.append(l);
                    });


                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });
    }


    Component{
        id: no_entry_item;
        Label{
            text: qsTr("No entries made yet")
            color: lkpalette.base_white;
            font.pointSize: 16;
            font.bold: true;
            font.italic: true;
            height: 30;
        }
    }
    Component{
        id: balance_sheet_item;
        Item{
            width: balance_sheet.width;
            height: 50;
            Item{
                anchors.fill: parent;
                anchors.margins: 5;
                Label{
                    text: note;
                    color: lkpalette.base_white;
                    anchors.left: parent.left;
                    anchors.verticalCenter: parent.verticalCenter;
                }
                Label{
                    text: post.toFixed(2) + " DKK";
                    color: lkpalette.base_white;
                    anchors.right: total.left;
                    anchors.rightMargin: 10;
                    anchors.verticalCenter: parent.verticalCenter;
                }
                Label{
                    id: total;
                    text: balance.toFixed(2) + " DKK";
                    color: lkpalette.base_white;
                    anchors.right: parent.right;
                    anchors.verticalCenter: parent.verticalCenter;
                }
                LKSeperator{}
            }
        }
    }

    ListModel{
        id: balance_sheet_data;
    }

    ListView{
        id: balance_sheet;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        model: balance_sheet_data;
        clip: true
        ScrollBar.vertical: LKScrollBar{
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }

    Component.onCompleted: {
        get_balance_sheet();
        header.headText = qsTr("BALANCE")
    }
}
