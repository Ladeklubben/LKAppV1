import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtQuick 2.12

Item {
    function get_sales(){
        http.request('/orders/sales', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    var cl = JSON.parse(o.responseText);
                    sales_data.clear();
                    if(cl.length === 0){
                        sales_sheet.delegate = no_entry_item;
                        sales_data.append({"NA": "Nothing"});
                        return;
                    }
                    sales_sheet.delegate = sales_item;
                    cl.forEach(function(l){
                        sales_data.append(l);
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
        id: sales_item;
        Item{
            width: sales_sheet.width;
            height: 50;
            Item{
                anchors.fill: parent;
                anchors.margins: 5;
                Label{
                    id:orderidlabel;
                    text: orderid;
                    color: lkpalette.base_white;
                    anchors.left: parent.left;
                    anchors.verticalCenter: parent.verticalCenter;
                }
                Label{
                    text: start === '' ? '-' : datetime.format_time(parseInt(start)*1000)
                    color: lkpalette.base_white;
                    anchors.left: orderidlabel.right;
                    anchors.leftMargin: 30;
                    anchors.verticalCenter: parent.verticalCenter;
                }
                Label{
                    text: consumption === '' ? '- kWh' : parseFloat(consumption).toFixed(2) + " kWh";
                    color: lkpalette.base_white;
                    anchors.right: costlable.left;
                    anchors.rightMargin: 30;
                    anchors.verticalCenter: parent.verticalCenter;
                }
                Label{
                    id: costlable;
                    text: cost === '' ? '- DKK' : parseFloat(cost).toFixed(2) + " DKK";
                    color: lkpalette.base_white;
                    anchors.right: parent.right;
                    anchors.verticalCenter: parent.verticalCenter;
                }
                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        activestack.push(orderview, {"orderno": orderid});
                    }
                }
                LKSeperator{}
            }
        }
    }

    ListModel{
        id: sales_data;
    }

    ListView{
        id: sales_sheet;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        model: sales_data;
        clip: true
        ScrollBar.vertical: LKScrollBar{
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }

    Component.onCompleted: {
        get_sales();
        header.headText = qsTr("SALES")
    }

    Component {
        id: orderview
        Item{
            property alias orderno: ow.orderno;
            OrderView{
                id: ow;

            }
        }
    }
}
