import QtQuick 2.14
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

MouseArea {
    GridLayout{
        anchors.fill: parent;
        anchors.rightMargin: 20;
        columns: 3;

        //''''''''''''''''''''''''''''''''''//
        Label{
            text: qsTr("Last year") + ":";
            color: "white"
            font.bold: true;
        }
        Label{
            text: readings.stat_lastyear;
            color: "white";
            Layout.fillWidth: false;
        }
        Label{
            text: "kWh";
            color: "white";
            Layout.fillWidth: false;
        }
        Label{
            text: qsTr("This year") + ":";
            color: "white"
            font.bold: true;
        }
        Label{
            text: readings.stat_year;
            color: "white";
            Layout.fillWidth: false;
        }
        Label{
            text: "kWh";
            color: "white";
            Layout.fillWidth: false;
        }

        //''''''''''''''''''''''''''''''''''//
        Label{
            text: qsTr("Current month") + ":";
            color: "white"
            font.bold: true;
        }
        Label{
            text: readings.stat_month;
            color: "white";
            Layout.fillWidth: false;
        }
        Label{
            text: "kWh";
            color: "white";
            Layout.fillWidth: false;
        }

        //''''''''''''''''''''''''''''''''''//
        Label{
            text: qsTr("Last month") + ":";
            color: "white"
            font.bold: true;
        }
        Label{
            text: readings.stat_last_month;
            color: "white";
            Layout.fillWidth: false;
        }
        Label{
            text: "kWh";
            color: "white";
            Layout.fillWidth: false;
        }
    }



    Component{
        id: statitem;
        RowLayout{
            property string label;
            property string val;
            width: parent.width;
            Label{
                text: label;
                color: "white"
            }
            Label{
                text: val
                color: "white";
                Layout.fillWidth: false;
            }
        }

    }

    Component.onCompleted: {
    }
}
