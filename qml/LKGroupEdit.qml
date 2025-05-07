import QtQuick
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Item {
    property var groupobj;
    property var groupid;
    property color groupcolor;
    property var parent_model;
    property var model_idx;

    function update_members_list(title){
        http.request('/group/' + groupid + '/members?groupname=' + title, '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    let members = JSON.parse(o.responseText);
                    invitespendingitems.clear();
                    members.forEach(function(memberid){
                        invitespendingitems.append({"memberid": memberid});
                    });
                    parent_model.setProperty(model_idx, "members", members.length)
                }
                else if(o.status === 400){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Unknown error")});
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

    function invite_member(member, title){
        let body = JSON.stringify({
                                      'member': member,
                                  }
                                  );
        http.put('/group/' + groupid + '/invite?groupname=' + title, body, function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    update_members_list(title);
                }
                else if(o.status === 400){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Unknown error")});
                }
                else if(o.status === 404){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Group number not known to the system")});
                }
                else if(o.status === 409){   //Member already invited
                    //Do nothing
                    console.log("Member already invited", o.responseText)
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

    function remove_member_from_group(member, title){
        let body = JSON.stringify({
                                      'member': member,
                                  }
                                  );
        http.put('/group/' + groupid + '/member_remove?groupname=' + title, body, function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    parent_model.setProperty(model_idx, "members", invitespendingitems.count)
                }
                else if(o.status === 400){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Unknown error")});
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



    ColumnLayout{
        width: parent.width;
        spacing: 10;

        LKTextEdit{
            id: memberinvite;
            Layout.fillWidth: true;
            height: 50;
            headline: qsTr("Invite member");
            text: ""
            color: "black";
            font.capitalization: Font.AllLowercase;
            inputMethodHints: Qt.ImhLowercaseOnly | Qt.ImhEmailCharactersOnly;
            validator: RegularExpressionValidator { regularExpression:/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }
        }
        LKButton{
            text: qsTr("Send invite");
            onClicked:{
                if(memberinvite.text.length == 0 || !memberinvite.acceptableInput) return;
                invite_member(memberinvite.text.toLowerCase(), groupobj.info.title);
            }
        }



        ListView{
            id: memberslv;

            ListModel{
                id: invitespendingitems;
            }

            Layout.preferredHeight: contentHeight;
            Layout.preferredWidth: parent.width;

            spacing: 5;

            clip: true;
            model: invitespendingitems
            delegate: Item{
                width: memberslv.width;
                height: 50;

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
                    id: flicker
                    property var listview_ptr: memberslv;   //Which Listview should have its interaction paused while flickering

                    property real update_rdy: 0;
                    flickableDirection: Flickable.HorizontalFlick;
                    width: parent.width;
                    height: parent.height;
                    interactive: true;
                    Rectangle{
                        width: parent.width;
                        height: parent.height;
                        radius: 5;
                        LKGroupTag{
                            gcolor: groupcolor;
                            anchors.fill: parent;
                            content: Label{
                                verticalAlignment: Label.AlignVCenter;
                                text: memberid;
                                font.pointSize: 16;
                            }
                        }
                    }

                    onMovementEnded: listview_ptr.interactive = true;
                    onMovementStarted: listview_ptr.interactive = false;

                    onContentXChanged: {
                        if(contentX < -width/3 && !update_rdy){
                            update_rdy = 1;
                            remove_member_from_group(memberid, groupobj.info.title);
                            invitespendingitems.remove(index)

                        }
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        update_members_list(groupobj.info.title);
    }
}
