import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Layouts 1.12

Item {
    Layout.preferredHeight: cl.implicitHeight + 10;
    ColumnLayout{
        id: cl
        LKLabel{
            font.pointSize: lkfont.sizeLarge;
            font.bold: true;
            text: qsTr("Cost") + ":";
        }

        LKLabel{
            text: (price).toFixed(2) + " " + valuta;
        }
        LKLabel{
            text:  "( " + (unitprice).toFixed(2) + "Kr/kWh ) " + qsTr("Estimated");
            font.pointSize: lkfont.sizeSmall
            color: lkpalette.seperator;
        }
    }

    LKSeperator{
    }
}
