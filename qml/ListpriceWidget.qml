import QtQuick 2.14
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

MouseArea {
    property double price: stationdata.listprice.nominal;
    property double min_price: stationdata.listprice.minimum;
    property string valuta: stationdata.listprice.valuta;

    ColumnLayout{
        anchors.fill: parent;
        anchors.margins: 10;
        Label{
            id: info
            color: lkpalette.text;
            font.pointSize: lkfont.sizeLarge
            text: qsTr("Standard price:");
        }

        GridLayout{
            columns: 3;
            columnSpacing: 10;
            //------------
            Label{
                text: qsTr("Price") + ":";
                color: "white"
            }
            Label{
                text: price.toLocaleString();
                color: "white";
                Layout.fillWidth: false;
            }
            Label{
                text: valuta;
                color: "white";
                Layout.fillWidth: false;
            }
            //------------------
            Label{
                text: qsTr("Min. price") + ":";
                color: "white"
            }
            Label{
                text: min_price.toLocaleString();
                color: "white";
                Layout.fillWidth: false;
            }
            Label{
                text: valuta;
                color: "white";
                Layout.fillWidth: false;
            }
        }
    }
    Rectangle{
        width: parent.width
        height: 1;
        color: lkpalette.seperator;
        anchors.bottom: parent.bottom;
        radius: 3;
    }

    onVisibleChanged: {
        if(visible){    //Workaround - so that it reflects when changed
            price = stationdata.listprice.nominal;
            min_price = stationdata.listprice.minimum;
            valuta = stationdata.listprice.valuta;
        }
    }
}
