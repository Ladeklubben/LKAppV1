import QtLocation 5.14
import QtPositioning 5.14
import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtCharts;


MouseArea{
    property Component station;

    property bool open: activestation.open;
    property bool free: activestation.connector === "Available" ? true : false;
    property var openhours: activestation.openhours;

    signal station_info_closed();


    onOpenhoursChanged: {
        var t = new Date();

        var day = t.getDay() - 1;
        if(day < 0){
            day += 7;
        }

        let now = t.getMinutes() + t.getHours()*60 + day*24*60;
        var matchstring = "";

        var closes_match_id = -1;
        var closes_match_day = -1;
        var closes_match_diff = 9999999;

        for(var j=0; j<openhours.length; j++){
            for(var i=0; i<openhours[j]['days'].length; i++){
                let start = openhours[j]['days'][i]*24*60 + openhours[j]['start'];
                let stop = start + openhours[j]['interval'];
                var diff;

                if(now >= start && now < stop){ //The charger is open and its a match
                    openeningtime.text = openening_strings.charger_open(openhours[j]);
                    return;
                }
                else if(now < start){
                    diff = start - now;
                }
                else{   //now > start
                    diff = (start + 7*24*60) - now;
                }

                if(diff < closes_match_diff){
                    closes_match_diff = diff;
                    closes_match_id = j;
                    closes_match_day = i;
                }
            }
        }
        if(closes_match_id !== -1){
            matchstring = openening_strings.charger_closed(openhours[closes_match_id], closes_match_day);
        }
        openeningtime.text = matchstring;
    }

    onClicked: {
        //Click outside the infobox to close it
        station_info_closed();
    }

    Rectangle{  //Main white area
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.margins: 5;
        height: 450;
        radius: 5;
        color: lkpalette.base_white;

        MouseArea{
            //Place the pricelist ontop of both the logo and the price
            z: 100;
            x: chargerimg.x;
            y: chargerimg.y;
            width: chargerimg.width;
            height: chargerimg.height + detailsrow.height + 30;
            onClicked: {
                alertbox.sourceComponent = chart;
            }

            Component{
                id: chart;
                MouseArea{
                    LKPriceBarChart{
                        //z: parent.z + 1;
                        listofprices: activestation.prices_ahead.Cost;
                        epoch_start: activestation.prices_ahead.start
                    }
                    onClicked: {
                        alertbox.sourceComponent = undefined
                    }
                }
            }
        }

        Item{
            id: chargerimg;
            anchors.top: parent.top;
            anchors.left: parent.left;
            width: parent.width/3;
            height: 100;
            Label{
                text: "\uE80A";
                anchors.centerIn: parent;
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter;
                color: lkpalette.base;
                font.family: lkfonts.name;
                font.pointSize: 60;
            }
        }

        ColumnLayout{
            anchors.left: chargerimg.right;
            anchors.top: parent.top;
            anchors.right: parent.right;
            anchors.margins: 15;

            Label{
                id: brieftag;
                font.pointSize: 20;
                text: activestation.location.brief;
                color: lkpalette.base;
            }
            Rectangle{
                width: 100;
                height: 40;
                color: free ? lkpalette.signalgreen : "red";
                radius: 5;
                Label{
                    text: free ? qsTr("Free") : qsTr("Occupied");
                    anchors.centerIn: parent;
                    color: lkpalette.base_white;
                    font.pointSize: 16;
                }
            }
        }


        ColumnLayout{

            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.top: chargerimg.bottom;
            anchors.margins: 15;
            property int rowheight: 75;

            RowLayout{
                id: detailsrow;
                Layout.fillWidth: true;
                height: 40;
                Rectangle{
                    Layout.fillWidth: true;
                    height: parent.height;

                    Row{
                        anchors.fill: parent;
                        LKIcon{
                            id: pricechartlogo;
                            height: parent.height;
                            text: "\uE818";
                            font.pointSize: lkfont.sizeSmall;
                            color: lkpalette.base;
                            horizontalAlignment: Text.AlignLeft;
                            verticalAlignment: Text.AlignVCenter;
                        }
                        Column{
                            id: pricedetails;
                            height: parent.height;
                            width: parent.width - pricechartlogo.width;
                            Row{
                                anchors.horizontalCenter: parent.horizontalCenter;
                                height: parent.height/2;
                                spacing: 5;
                                Label{
                                    id: pricetag;
                                    text: (activestation.sellingprice + activestation.discount).toFixed(2) + " kr";
                                    height: parent.height;
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignBottom;
                                    color: lkpalette.base;
                                    font.strikeout: selleingpricetag.visible;
                                }
                                Label{
                                    id: selleingpricetag;
                                    text: (activestation.sellingprice).toFixed(2) + " kr";
                                    height: parent.height;
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignBottom;
                                    color: lkpalette.base;
                                    visible: activestation.discount > 0;
                                }
                            }
                            Label{
                                text: "per kWh";
                                width: parent.width;
                                height: parent.height/2;
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignTop;
                                color: lkpalette.base;
                                font.pointSize: 10;
                            }
                        }
                    }
                }
                Rectangle{
                    Layout.fillWidth: false;
                    width: 1;
                    height: parent.height;
                    color: lkpalette.base_grey;
                }
                Rectangle{
                    Layout.fillWidth: true;
                    height: parent.height;
                    Column{
                        anchors.fill: parent;
                        Label{
                            id: capacitytag;
                            text: "11 kW";
                            width: parent.width;
                            height: parent.height/2;
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignBottom;
                            color: lkpalette.base;
                        }
                        Label{
                            text: qsTr("Capacity");
                            width: parent.width;
                            height: parent.height/2;
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignTop;
                            color: lkpalette.base;
                            font.pointSize: 10;
                        }
                    }
                }
                Rectangle{
                    Layout.fillWidth: false;
                    width: 1;
                    height: parent.height;
                    color: lkpalette.base_grey;
                }
                Rectangle{
                    Layout.fillWidth: true;
                    height: parent.height;
                    Column{
                        anchors.fill: parent;
                        Label{
                            id: conntypetag;
                            text: "Type 2"
                            width: parent.width;
                            height: parent.height/2;
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignBottom;
                            color: lkpalette.base;
                        }
                        Label{
                            text: qsTr("Connector");
                            width: parent.width;
                            height: parent.height/2;
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignTop;
                            color: lkpalette.base;
                            font.pointSize: 10;
                        }
                    }
                }
            }
            Item{
                //Spacing item
                height: parent.rowheight/2;
                Layout.fillWidth: true
            }

            LKTextFieldV2{
                id: openeningtime
                height: parent.rowheight;
                Layout.fillWidth: true
                headline: qsTr("Opening hours")
            }
            LKTextFieldV2{
                id: addr;
                height: parent.rowheight;
                Layout.fillWidth: true
                headline: qsTr("Adress")
                text: activestation.location.address + ", " + activestation.location.city;
            }

        }


        MouseArea{  //Bottom part (Button) Used only to disable the main button
            anchors.fill: parent;
        }

        LKButton{
            id: claimbutton;

            function getText(){
                if(open && free){
                    return qsTr("CLAIM");
                }
                else if(active_charging_session == activestation.stationid){
                    return qsTr("CHARGING")
                }

                return qsTr("UNAVAILABLE");
            }

            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.margins: 15;

            height: 60;
            text: getText();
            bold: true;
            color: lkpalette.signalgreen;
            button_radius: 5;
            enabled: (open && free) || active_charging_session == activestation.stationid;

            function after_login(){
                activestack.setLastActiveStack();
                claim(activestation.stationid);
            }

            onClicked: {
                if(!loggedin){
                    alertbox.sourceComponent = guest_warning;
                    return;
                }
                claim(activestation.stationid);
            }

            Component{
                id: guest_warning
                LKAlertBox{
                    message: qsTr("You are not logged in. Do you want to continue as guest?");

                    buttons:LKButtonV2 {
                        text: qsTr("OK");



                        onClicked: {
                            activestack.push(loginstack, {'request_guest_login': true, 'after_login_do': claimbutton.after_login});
                            alertbox.sourceComponent = undefined;
                        }
                    }
                }
            }

        }
    }
}
