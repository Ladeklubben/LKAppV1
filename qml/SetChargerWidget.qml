import QtQuick 2.0
import QtQuick.Window 2.13
import QtQuick.Controls 2.14
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtLocation 5.14
import QtPositioning 5.14

Item{
    property Component donewidget;

    property string brief: "";
    property string address: "";
    property string city: "";
    property string zip: "";
    property real latitude: -1;
    property real longitude: -1;

    property string model: "";
    property string brand: "";
    property string psize: "";
    property string conntype: "";

    property bool address_locked: false;

    signal edited();

    onBriefChanged: edited();
    onAddressChanged: edited();
    onCityChanged: edited();
    onZipChanged: edited();
    onLatitudeChanged: edited();
    onLongitudeChanged: edited();

    onModelChanged: edited();
    onBrandChanged: edited();
    onPsizeChanged: edited();
    onConntypeChanged: edited();

    function updateAddress(location){
        var streetnumber = location.address.text;
        streetnumber = streetnumber.split(",")[0];

        address = location.address.street + " " + streetnumber;
        city = location.address.city;
        zip = location.address.postalCode;
    }


    property Component nextWidget;
    LKStackView{
        id: cwcontrolstack;
        //property var lastActiveStack;
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: buttons.top;
        anchors.margins: 15;

        initialItem: CWPlaceCharger{
            Component.onCompleted: {
                nextWidget = setType;
            }
        }
//        Component.onCompleted: {
//            lastActiveStack = activestack;
//            activestack = cwcontrolstack;
//        }
//        Component.onDestruction: {
//            activestack = lastActiveStack;
//        }
        onCurrentItemChanged: {
            if(currentItem.isLast){
                buttons.sourceComponent = donewidget;
            }
            else{
                buttons.sourceComponent = buttons_next;
            }
        }
    }

    Component{
        id: setType;
        CWChargerType{
            property bool isLast: true;
        }
    }

    Component{
        id: buttons_next;
        RowLayout{
            LKButton{
                text: qsTr("CANCEL")
                Layout.fillWidth: true;
                Layout.fillHeight: true;
                onClicked: cancel();
            }
            LKButton{
                text: qsTr("NEXT");
                Layout.fillWidth: true;
                Layout.fillHeight: true;
                onClicked: {
                    cwcontrolstack.push(nextWidget);
                }
            }
        }
    }

    Loader{
        id: buttons;
        sourceComponent: donewidget;
        width: parent.width;
        height: 100;
        anchors.bottom: parent.bottom;
    }
}
