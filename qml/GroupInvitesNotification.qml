import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    property string headertext: qsTr("GROUP INVITES")

    function invite_accept(grouptoken){
        http.put('/group/invite_accept', JSON.stringify(grouptoken), function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {

                    for(let j=0; j<grouptoken.length; j++){
                        let token = grouptoken[j];
                        for(let i=0; i<guestgroups.guest_pending_invites.count; i++){
                            let obj = guestgroups.guest_pending_invites.get(i);
                            if(obj.inviteid === token){
                                guestgroups.guest_pending_invites.remove(i);
                                break;
                            }
                        }
                    }

                    if(guestgroups.guest_pending_invites.count === 0){
                        activestack.pop();
                    }
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

    function invite_decline(grouptoken, obj){
        http.put('/group/invite_decline', JSON.stringify(grouptoken), function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {

                    for(let j=0; j<grouptoken.length; j++){
                        let token = grouptoken[j];
                        for(let i=0; i<guestgroups.guest_pending_invites.count; i++){
                            let obj = guestgroups.guest_pending_invites.get(i);
                            if(obj.inviteid === token){
                                guestgroups.guest_pending_invites.remove(i);
                                break;
                            }
                        }
                    }

                    if(guestgroups.guest_pending_invites.count === 0){
                        activestack.pop();
                    }
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
        anchors.margins: 10;

        ListView{
            id: inviteslv;

            width: parent.width;
            height: parent.height - bottombar.height;

            spacing: 25;

            clip: true;
            model: guestgroups.guest_pending_invites;
            delegate: Item{
                id: delegateobj;
                width: inviteslv.width;
                height: txt.contentHeight + 30;

                Label{
                    visible: flicker.contentX > 0;
                    anchors.right: parent.right;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.rightMargin: 30;
                    color: lkpalette.signalgreen;
                    text: qsTr("ACCEPT");
                    font.bold: true;
                    font.pointSize: 16;
                }

                Label{
                    visible: flicker.contentX < 0;
                    anchors.left: parent.left;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.leftMargin: 30;
                    color: "red";
                    text: qsTr("DECLINE");
                    font.bold: true;
                    font.pointSize: 16;
                }

                Flickable{
                    id: flicker;
                    property real update_rdy: 0;
                    flickableDirection: Flickable.HorizontalFlick;
                    width: parent.width - 20;
                    height: parent.height;
                    anchors.centerIn: parent;
                    interactive: true;
                    Rectangle{
                        radius: 5;
                        width: parent.width;
                        height: parent.height;
                        Text{
                            id: txt
                            width: parent.width - 10;
                            height: contentHeight;
                            anchors.verticalCenter: parent.verticalCenter;
                            anchors.centerIn: parent;
                            text: owner + " " + qsTr("has invited you to a ") + " " + group_type + " " + qsTr("group named") + " " + group_name;
                            font.pointSize: 16;
                            wrapMode: Text.Wrap;
                        }
                    }
                    onContentXChanged: {
                        if(contentX < -width/3 && !update_rdy){
                            update_rdy = 1;
                            invite_decline([inviteid]);
                        }
                        else if(contentX > width/3 && !update_rdy){
                            update_rdy = 1;
                            invite_accept([inviteid]);
                        }
                    }
                    onMovementStarted: {
                        inviteslv.interactive = false;
                    }

                    onMovementEnded: {
                        inviteslv.interactive = true;
                        update_rdy = 0;
                    }
                }
            }
        }

        RowLayout{
            id: bottombar;
            anchors.bottom: parent.bottom;
            width: parent.width;
            height: 100;
            LKButton{
                id: acceptbot;
                Layout.fillWidth: true;
                text: qsTr("Accept all")

                onClicked: {
                    declinebot.enabled = false;
                    acceptbot.enabled = false;
                    let tbd = [];
                    for(let i=0; i<guestgroups.guest_pending_invites.count; i++){
                        let inviteobj = guestgroups.guest_pending_invites.get(i);
                        tbd.push(inviteobj.inviteid);
                    };
                    invite_accept(tbd);
                }
            }
            LKButton{
                id: declinebot
                Layout.fillWidth: true;
                text: qsTr("Decline all")
                enabled: true;

                onClicked: {
                    declinebot.enabled = false;
                    acceptbot.enabled = false;
                    let tbd = [];
                    for(let i=0; i<guestgroups.guest_pending_invites.count; i++){
                        let inviteobj = guestgroups.guest_pending_invites.get(i);
                        tbd.push(inviteobj.inviteid);
                    };
                    invite_decline(tbd);
                }
            }
        }
    }
}
