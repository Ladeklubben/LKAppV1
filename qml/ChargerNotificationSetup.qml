import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtQuick

Item {
    function get_notifications(){
        http.request("/cp/" + activeCharger.id + "/notification_setup", '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    var cl = JSON.parse(o.responseText);
                    notifications.clear();
                    if('onBegin' in cl){
                        cl['onBegin'].forEach(function(l){
                            notifications.append({
                                                     "kind": 0,
                                                     "email": l[0],
                                                     "notification_enabled": l[1] === 1,
                                                 })
                        });
                    }
                    if('onEnd' in cl){
                        cl['onEnd'].forEach(function(l){
                            notifications.append({
                                                     "kind": 1,
                                                     "email": l[0],
                                                     "notification_enabled": l[1] === 1,
                                                 })
                        });
                    }
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });
    }

    function update_notificationsetup(email, kind, enable){
        var obj = {
            'email': email,
            'eventType': kind === 0 ? 'onBegin' : 'onEnd',
            'enabled': enable,
        }
        http.put("/cp/" + activeCharger.id + "/notification_setup", JSON.stringify(obj), function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    get_notifications();
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });
    }

    function remove_notificationsetup(email, kind, enable){
        var obj = {
            'email': email,
            'eventType': kind === 0 ? 'onBegin' : 'onEnd',
            'enabled': enable,
        }

        http.put("/cp/" + activeCharger.id + "/notification_setup/delete", JSON.stringify(obj), function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    get_notifications();
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });
    }

    Component{
        id: notification_item;
        Item{
            height: 100;
            width: notifications_lw.width;

            Label{
                visible: flicker.contentX < 0;
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.leftMargin: 30;
                color: "red";
                text: qsTr("REMOVE");
                font.bold: true;
                font.pointSize: 16;
            }

            Flickable{
                id: flicker;
                property real update_rdy: 0;
                interactive: true;
                flickableDirection: Flickable.HorizontalFlick;
                width: parent.width;
                height: parent.height;

                onMovementEnded: {
                    update_rdy = 0;
                    notifications_lw.interactive = true;
                }
                onMovementStarted: notifications_lw.interactive = false;

                onContentXChanged: {
                    if(contentX < -width/3 && !update_rdy){
                        update_rdy = 1;
                        remove_notificationsetup(email, kind, !notification_enabled);
                        notifications.remove(index)
                    }
                }

                Rectangle{
                    id: content;
                    anchors.fill: parent;
                    color: lkpalette.base;
                    border.color: notification_enabled ? lkpalette.signalgreen : "red";
                    border.width: 2;

                    Item{
                        anchors.fill: parent;
                        anchors.margins: 5;

                        Label{
                            id: email_txt;
                            text: email;
                            color: lkpalette.base_white;
                            anchors.left: parent.left;
                            anchors.verticalCenter: parent.verticalCenter;
                            font.pointSize: lkfont.sizeNormal;
                        }
                        Label{
                            text: kind === 0 ? qsTr("charging start") : qsTr("charging end");
                            color: lkpalette.base_white;
                            anchors.right: parent.right;
                            anchors.verticalCenter: parent.verticalCenter;
                            font.pointSize: lkfont.sizeNormal;
                        }
                        LKSeperator{}

                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                update_notificationsetup(email, kind, !notification_enabled);
                            }
                        }
                    }
                }
            }
        }
    }

    ListModel{
        id: notifications;
    }

    ListView{
        id: notifications_lw;
        anchors.margins: 5;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: parent.top;
        anchors.bottom: add_notification.top;
        spacing: 5;
        model: notifications;
        delegate: notification_item;
        clip: true;
    }

    Item{
        id: add_notification;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.margins: 5;
        height: 200;
        property int kind: 0;
        ColumnLayout{
            anchors.fill: parent;
            spacing: 15;
            LKTextEdit{
                id: email_input;
                headline: qsTr("Email");
                width: parent.width;
                Layout.fillWidth: true;
                inputMethodHints: Qt.ImhLowercaseOnly | Qt.ImhEmailCharactersOnly;
                validator: RegularExpressionValidator { regularExpression:/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }
                indicate_error: !acceptableInput && text.length > 0;
            }
            RowLayout{
                height: 40;
                Layout.fillWidth: true;
                spacing: 5;
                Label{
                    text: qsTr("Pick event") + ":";
                    Layout.fillWidth: false;
                    height: parent.height;
                    color: lkpalette.base_white;
                    font.pointSize: lkfont.sizeNormal;
                }

                Rectangle{
                    id: kind_picker;
                    Layout.fillWidth: true;
                    height: parent.height;
                    color: "transparent";
                    border.color: lkpalette.base_white;
                    border.width: 2;
                    radius: 5;

                    Label{
                        id: toggle_text;
                        anchors.centerIn: parent;
                        text: add_notification.kind === 0 ? qsTr("on charging begin") : qsTr("on charging end");
                        font.pointSize: lkfont.sizeNormal;
                        color: lkpalette.base_white;
                    }
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: {
                            add_notification.kind = add_notification.kind === 0 ? 1 : 0;
                        }
                    }
                }
            }
            LKButtonV2{
                text: qsTr("Submit");
                Layout.fillWidth: true;
                Layout.fillHeight: true;
                onClicked: {
                    update_notificationsetup(email_input.text, add_notification.kind, 1);
                    //email_input.text = "";
                }
                enabled: email_input.acceptableInput;
            }
        }
    }

    Component.onCompleted: {
        get_notifications();
        header.headText = qsTr("Notifications")

    }
}
