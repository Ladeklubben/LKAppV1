import QtLocation
import QtPositioning
import QtQuick
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtCore

Item{
    id: map_page;

    signal claim(var id);
    property int appstate: activestate;

    LKMap {
        id: map
        anchors.fill: parent;

        onFollow_positionChanged: {
            if(follow_position && positionSource.valid){
                map.center = current_pos.coordinate;
            }
        }

        ColumnLayout{
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 20;
            width: 70
            spacing: 15;

            LKIconButton{   //QR
                text: "\uE80C"
                Layout.preferredHeight: 50
                Layout.fillWidth: true;
                Layout.fillHeight: false;
                color: lkpalette.base;
                onClicked: {
                    activeqr = '';
                    camerapermission.prepare_camera_permission();
                }
                CameraPermission{
                    id: camerapermission;
                    function prepare_camera_permission(){
                        if(status == Qt.Undetermined || status == Qt.Denied){
                            request();
                        }
                        else if(status == Qt.Granted){
                            activestack.push(qrscanner);
                        }
                    }
                    onStatusChanged:{
                        if(status == Qt.Granted){
                            activestack.push(qrscanner);
                        }
                    }
                }
            }
            LKIconButton{   //Location
                text: "\uE806";  //TARGET AIM
                Layout.preferredHeight: 50
                Layout.fillHeight: false;
                Layout.fillWidth: true;
                color: lkpalette.base;
                visible: !map.follow_position && locationpermission.status == Qt.Granted && infoloader.source == '';
                onClicked: {
                    map.follow_position = true;
                }
            }
            LKIconButton{   //Active Charger
                text: "\uE81F";
                Layout.preferredHeight: 50
                Layout.fillHeight: false;
                Layout.fillWidth: true;
                color: lkpalette.base;
                visible: active_charging_session != '';
                onClicked:{
                    let o = mdata.get_stationobj(active_charging_session);
                    if(o != null){
                        infoloader.activestation = o;
                        infoloader.setSource("LKMapStationInfo.qml");
                    }
                }
            }
        }

        MapItemView {
            model: list_of_markers;
            delegate: MapQuickItem {
                id: marker
                property bool open: stationobj.open;
                property bool free: stationobj.connector === "Available";

                coordinate: QtPositioning.coordinate(stationobj.location.latitude, stationobj.location.longitude);
                anchorPoint.x: mark_pos.width/2
                anchorPoint.y: mark_pos.height; ///2
                sourceItem: MouseArea{
                    id: markerarea
                    width: 50;
                    height: 50;

                    onClicked: {
                        infoloader.activestation = stationobj;
                        infoloader.setSource("LKMapStationInfo.qml");
                    }

                    Label{
                        id: mark_pos;
                        text: "\uE809";
                        font.pointSize: 35;
                        color: (open && free) ? lkpalette.base : "red";
                        font.family: lkfonts.name;
                    }
                }
            }
        }

        MapQuickItem {
            id: current_pos;
            anchorPoint.x: you_pos.width/2
            anchorPoint.y: you_pos.height/2
            sourceItem: Rectangle {
                id: you_pos;
                width: 15;
                height: 15;
                color: "blue"
                radius: width / 2;
                opacity: 0.9
            }
            visible: locationpermission.status == Qt.Granted && positionSource.valid;
            coordinate: positionSource.position.coordinate
        }
    }

    Loader{
        id: infoloader;
        anchors.fill: parent;
        property string qr: activeqr;
        property var activestation; //We need to set this before we load the compoent
        source: '';
        onActivestationChanged: {
            //Destroy stationinfo if station is made non-public
            if(activestation === null)
                infoloader.source = '';
            else{
                map.zoomLevel = 20;
                map.center = QtPositioning.coordinate(activestation.location.latitude, activestation.location.longitude);
                map.pan(0,250)
                map.follow_position = false;
            }
        }
        onQrChanged: {
            if(qr === ''){
                activestation = null;
                return;
            }

            console.log("QR changed - switch the active station");
            activestation = null;
            var stationobj = mdata.get_station_from_qr(qr);
            if(stationobj !== null){
                infoloader.activestation = stationobj;
                infoloader.setSource("LKMapStationInfo.qml", {"station":  stationobj});
            }
        }

        Connections {
            target: infoloader.item
            function onStation_info_closed() {
                infoloader.source = '';
            }
        }
    }


    PositionSource {
        id: positionSource

        updateInterval: 5000;
        onPositionChanged: {
            if(map.follow_position){
                map.center = position.coordinate;
            }
            current_pos.coordinate = position.coordinate;

            //Store the last known gps point
            maplocation.last_center = {
                "latitude": position.coordinate.latitude,
                "longitude": position.coordinate.longitude
            }
        }
        preferredPositioningMethods: PositionSource.AllPositioningMethods;
        onSourceErrorChanged: {
            if (sourceError == PositionSource.NoError)
                return
            stop()
        }
    }

    LocationPermission {
        id: locationpermission;

        onStatusChanged:{
            if(status == Qt.Granted){
                positionSource.active = true;
            }
        }

        Component.onCompleted: {
            if(status == Qt.Undetermined || status == Qt.Denied){
                request();
            }
            else if(status == Qt.Granted){
                positionSource.active = true;
            }

            if(maplocation.last_center !== undefined){
                if(status == Qt.Granted)
                    current_pos.coordinate = QtPositioning.coordinate(maplocation.last_center['latitude'], maplocation.last_center['longitude']);
                map.center = QtPositioning.coordinate(maplocation.last_center['latitude'], maplocation.last_center['longitude']);
            }
            else{
                //current_pos.coordinate = map.center;
            }
        }
    }

    onAppstateChanged:{
        switch (appstate) {
        case Qt.ApplicationSuspended:
            positionSource.stop();
            break;
        case Qt.ApplicationHidden:
        case Qt.ApplicationInactive:
            break;
        case Qt.ApplicationActive:
            if(locationpermission.status == Qt.Granted && positionSource.active == false){
                positionSource.start();
            }
        break
        }
    }
}
