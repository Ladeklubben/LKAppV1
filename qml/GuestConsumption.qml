import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Layouts 1.12

Item {
    Layout.preferredHeight: cl.implicitHeight + 10;
    ColumnLayout{
        id: cl;
        LKLabel{
            font.pointSize: lkfont.sizeLarge;
            font.bold: true;
            text: qsTr("Consumption") + ":";
        }

        RowLayout{
            spacing: 25;
            LKLabel{
                text: consumption.toFixed(2) + " kWh";
            }
            LKLabel{
                text: power.toFixed(2) + " kW";
                visible: charging;
            }
        }
    }

    LKSeperator{
    }
}
