import QtQuick
import QtQuick.Controls
import Qt.labs.settings
import QtQuick.Layouts
import QtLocation
import QtPositioning

ColumnLayout{
    spacing: 25;
    id: placeChargerMap
    property string brief: "";
    property string address: "";
    property string city: "";
    property string zip: "";
    property real latitude;
    property real longitude;

    property bool address_locked: false;

    property bool changed: false;

    onBriefChanged: {
        changed = true;
        header.subtext = getSubText(brief)
    }
    onAddressChanged: changed = true;
    onCityChanged: changed = true;
    onZipChanged: changed = true;
    onLatitudeChanged:{
        changed = true;
    }
    onLongitudeChanged:{
        changed = true;
    }


    function updateAddress(location){
        var streetnumber = location.address.text;
        streetnumber = streetnumber.split(",")[0];

        address = location.address.street + " " + streetnumber;
        city = location.address.city;
        zip = location.address.postalCode;
    }

    function getSubText(brief){
        return brief? address + " - " + brief : ""
    }


    Component.onCompleted: {
        header.headText = qsTr("Place Station")
        header.subtext = ""

        if(stationinfo !== undefined){
            brief = stationinfo.brief ?? "";
            address = stationinfo.address ?? "";
            city = stationinfo.city ?? "";
            zip = stationinfo.zip ?? "";
            latitude =  stationinfo.latitude ?? -1;
            longitude = stationinfo.longitude ?? -1;
        }

        if(latitude != -1 && longitude != -1){
            map.center.latitude = latitude;
            map.center.longitude = longitude;
            map.zoomLevel = 18;
        }
        else{
            map.zoomLevel = 5;
            map.center = QtPositioning.coordinate(56.384195, 9.247259);
        }
        changed = false;


    }


    RowLayout{
        width: parent.width;
        Layout.preferredHeight: 40;
        Layout.fillWidth: true;
        Layout.fillHeight: false;

        LKLabel{
            text: qsTr("Brief desc.") + ":";
            font.bold: true;
            Layout.fillWidth: false;
            verticalAlignment: Text.AlignVCenter;
        }
        LKTextEdit{
            Layout.fillWidth: true;
            horizontalAlignment: TextInput.AlignHCenter;
            verticalAlignment: TextInput.AlignVCenter;
            text:  brief;
            onTextChanged: {
                brief = text;
            }
        }
    }

    ColumnLayout {
        Layout.fillHeight: true;
        Layout.fillWidth: true;
        Item{
            Layout.fillHeight: true;
            Layout.fillWidth: true;
            LKMap{
                id: map;
                anchors.fill: parent;
                zoomLevel: 7
                MapQuickItem {
                    id: marker
                    coordinate: map.center;
                    anchorPoint.x: mark_pos.width/2
                    anchorPoint.y: mark_pos.height/2
                    sourceItem: Rectangle {
                        id: mark_pos;
                        width: 15;
                        height: width;
                        color: "blue"
                        radius: width / 2;
                        opacity: 0.9
                    }
                }

                onCenterChanged: {
                    updateaddresstimer.restart();
                }
                Component.onCompleted:{
                    changed = false;
                    updateaddresstimer.stop();
                }

                layer.enabled: true
            }


            Timer{
                id: updateaddresstimer;
                interval: 1000;
                triggeredOnStart: false;
                onTriggered: {
                    if(address_locked){
                        return;
                    }
                    if(map.zoomLevel >= 18){
                        latitude = map.center.latitude;
                        longitude = map.center.longitude;
                        geocodeModel.query = map.center;
                        geocodeModel.update()
                    }
                }
            }

            GeocodeModel {
                id: geocodeModel
                plugin: Plugin {
                    name: "osm"
                    PluginParameter { name: "osm.useragent"; value: "Ladeklubben" }
                }

                onLocationsChanged:
                {
                    if (!changed) return;

                    if (count > 0) {
                        updateAddress(get(0));
                    }
                }
            }
        }
        Item{
            id: lockarea;
            height: 25;
            Layout.fillWidth: true;
            RowLayout{
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                Image {
                    Layout.fillWidth: false;
                    id:lockicon;
                    source: address_locked ? "../icons/lock-locked_white.svg" : "../icons/lock-unlocked_white.svg"
                    sourceSize.height: lockarea.height;
                    sourceSize.width: height;
                }
                Label{
                    Layout.fillWidth: true;
                    color: "White";
                    font.bold: true;
                    font.pointSize: lkfont.sizeSmall;
                    text: address_locked ? qsTr("You can fintune the map without changing the address") : qsTr("When you zoom enough, the address will update");
                }
            }
            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    address_locked = !address_locked;
                }
            }
        }
    }

    GridLayout{
        columns: 2;
        rowSpacing: 10;
        Layout.fillHeight: false;
        Layout.fillWidth: true;
        Label{
            color: "White";
            font.bold: true;
            font.pointSize: lkfont.sizeSmall;
            text: qsTr("Address") + ":";
        }
        Label{
            color: "White";
            font.pointSize: lkfont.sizeSmall;
            text: address;
        }
        Label{
            color: "White";
            font.bold: true;
            font.pointSize: lkfont.sizeSmall;
            text: qsTr("City") + ":";
        }
        Label{
            color: "White";
            font.pointSize: lkfont.sizeSmall;
            text: city;
        }
        Label{
            color: "White";
            font.bold: true;
            font.pointSize: lkfont.sizeSmall;
            text: qsTr("Zip") + ":";
        }
        Label{
            color: "White";
            font.pointSize: lkfont.sizeSmall;
            text: zip;
        }
    }
}
