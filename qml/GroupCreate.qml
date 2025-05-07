import QtQuick 2.13
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Item {
    property string headertext: qsTr("NEW GROUP");
    property bool ready_to_create: false;
    property Component tariff_component;
    property string input_tariff;
    property var groupobj;

    property int groupid;

    property alias tarifitem : tariffloader.item;

    function create_group(title, tariff, brief, stations){
        let body = JSON.stringify({
                                      'title': title,
                                      'tariff': tariff,
                                      'brief': brief,
                                      'stations': stations,
                                  }
                                  );
        http.post('/group/' + groupid + '/create', body, function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    ownergroups.get_groups_list();
                    activestack.pop();
                }
                else if(o.status === 400){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Unknown error")});
                }
                else if(o.status === 403){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Group already exists - please rename")});
                }
                else if(o.status === 404){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Group number not known to the system")});
                }
                else if(o.status === 0){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });
    }

    function update_group(body){
        http.post('/group/' + groupid + '/update', body, function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    ownergroups.get_groups_list();
                    activestack.pop();
                }
                else if(o.status === 400){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Unknown error")});
                }
                else if(o.status === 403){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Group already exists - please rename")});
                }
                else if(o.status === 404){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Group number not known to the system")});
                }
                else if(o.status === 0){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });

    }

    Item{
        anchors.fill: parent;
        anchors.leftMargin: 10;
        anchors.rightMargin: 10;
        anchors.bottomMargin: 10;

        ColumnLayout{
            id: groupinfowidget;
            width: parent.width;
            spacing: 10;
            LKTextEdit{
                id: grouptitle;
                Layout.fillWidth: true;
                height: 50;
                headline: qsTr("Title");
                text: ""
                color: "black";
                maximumLength: 100;
                font.italic: !enabled
            }

            LKTextEdit{
                id: groupbrief;
                property bool something: false;
                Layout.fillWidth: true;
                height: 50;
                headline: qsTr("Brief");
                text: ""
                color: "black";
                maximumLength: 100;
                onTextChanged: something = true;
                Component.onCompleted: {
                    something = false;
                }
            }

            Loader{
                id: tariffloader;

                property bool rdy: sourceComponent == null ? true : tariffloader.item.acceptableInput;

                sourceComponent: tariff_component;
                height: tariff_component !== undefined ? 50 : 0;
                Layout.fillWidth: true;
            }
        }
        LKStationListViewTmp{
            id: stationslist;

            anchors.top: groupinfowidget.bottom;
            anchors.bottom: activebuttonloader.top;
            anchors.left: parent.left;
            anchors.right: parent.right;

            header: Rectangle{
                height: 30;
                width: parent.width;
                color: lkpalette.base;
                Label{
                    width: parent.width;
                    height: parent.height;
                    text: qsTr("INCLUDE STATIONS");
                    font.pointSize: 16;
                    horizontalAlignment: Qt.AlignHCenter;
                    verticalAlignment: Qt.AlignVCenter;
                    color: lkpalette.buttonText;
                }
            }
        }

        Loader{
            id: activebuttonloader
            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
        }

        Component{
            id: createbutton;
            LKButton{
                text: qsTr("Submit");
                enabled: grouptitle.length > 3 && tariffloader.rdy;

                onClicked: {
                    if(tariffloader.sourceComponent == null)
                        create_group(grouptitle.text, 0, groupbrief.text, stationslist.pickedStations);
                    else
                        create_group(grouptitle.text, Number.fromLocaleString(tarifitem.tariff), groupbrief.text, stationslist.pickedStations);
                }
            }
        }
        Component{
            id: updatebutton;
            LKButton{
                property bool test: stationslist.something == true;
                onTestChanged: {
                    enabled = true;
                }
                property bool test2: groupbrief.something == true;
                onTest2Changed: {
                    if(groupbrief.text !== groupobj.info.brief){
                        enabled = true;
                    }
                }
                property string test3: tarifitem === null ? '' : tarifitem.tariff;
                onTest3Changed: {
                    if(!tariffloader.rdy) return;

                    let t = Number.fromLocaleString(tarifitem.tariff);
                    if(t !== groupobj.info.tariff){
                        enabled = true;
                    }
                }


                text: qsTr("Update");
                onClicked: {
                    var o = {
                        'title': grouptitle.text,
                    };
                    if(stationslist.something){
                        o['stations'] = stationslist.pickedStations;
                    }
                    if(groupbrief.something){
                        o['brief'] = groupbrief.text;
                    }
                    if(tariffloader.sourceComponent == null){
                    }
                    else{
                        if(tariffloader.rdy){
                            let t = Number.fromLocaleString(tarifitem.tariff);
                            if(t !== groupobj.info.tariff)
                                o['tariff'] = t
                        }
                    }
                    update_group(JSON.stringify(o));
                }
            }
        }
    }


    Component.onCompleted: {
        try{
            if(groupobj !== undefined){
                grouptitle.text = groupobj.info.title;
                grouptitle.enabled = false;
                groupbrief.text = groupobj.info.brief;

                stationslist.pickedStations = groupobj.stations;
                activebuttonloader.sourceComponent = updatebutton;
                activebuttonloader.item.enabled = false;
                if(tariffloader.sourceComponent != null)
                    tarifitem.tariff = groupobj.info.tariff;
                return;
            }
        }
        catch(error){
            console.log("***************", error);
        }
        activebuttonloader.sourceComponent = createbutton;
    }
}


