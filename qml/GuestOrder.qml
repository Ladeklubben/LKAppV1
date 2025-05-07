import QtQuick 2.13
import QtQuick.Window 2.13
import QtQml 2.12
import QtQuick.Layouts 1.12

Item {
    property double starttime: orderstart;
    property double stoptime: orderstop;

    Layout.preferredHeight: cl.implicitHeight + 10

    ColumnLayout{
        id: cl;
        GridLayout{
            columns: 2;
            columnSpacing: 20;
            rowSpacing: 20;

            LKLabel{
                font.bold: true;
                text: qsTr("Order") + ":";
            }
            LKLabel{
                text: orderno ? orderno : '-';
            }

            LKLabel{
                font.bold: true;
                text: "Station ID:";
            }
            LKLabel{
                text: stationid + (station_info?.brief ? "<br><i>(" + station_info.brief + ")</i>" : '')
                textFormat: Text.RichText
            }

            LKLabel{
                font.bold: true;
                text: qsTr("Owner") + ":";
            }
            LKLabel{
                text: owner_info?.companyName ? owner_info.companyName : (owner_info?.name ?? "")
            }

            LKLabel{
                font.pointSize: lkfont.sizeNormal;
                font.bold: true;
                text: qsTr("Address") + ":";
            }
            LKLabel{
                font.pointSize: lkfont.sizeNormal;
                text: station_info == undefined ? '' :
                                                  station_info['address'] + '\r\n' +
                                                  station_info['zip'] + ' ' + station_info['city'];
            }

            LKLabel{
                font.bold: true;
                text: qsTr("Started") + ":";
            }
            LKLabel{
                id: start;
                text: orderstart
            }
            LKLabel{
                font.bold: true;
                text: qsTr("Stopped") + ":";
            }

            LKLabel{
                id: stop;
                text: ""
            }
        }
    }

    LKSeperator{
    }

    onStarttimeChanged: {
        var t = new Date(starttime*1000);
        start.text = t.toLocaleString("da-DK");

        if(charging){
            stop.text = '';
        }
    }
    onStoptimeChanged: {
        var t = new Date(stoptime*1000);
        stop.text = t.toLocaleString("da-DK");
    }
}
