import QtQuick

Item {
    function change_user_cb(ok, info){
        if(!ok) return;
        userinfo = info['userinfo'];
        loggedin = true;
        console.log("Logged in!", userinfo['name'], JSON.stringify(info));
        ownergroups.data = info.groups;
        guestgroups.guest_stations.clear();
        guestgroups.data = info.guestgroups;

        payment = info.payment;

        stations = info.stations;
        activestack.pop();

        if(guestgroups.pending_invites.length > 0){
            activestack.push(group_invites);
        }
    }

    Column{
        spacing: 20;
        anchors.fill: parent;
        anchors.margins: 20
        LKMenuItem{
            height: 85;
            width: parent.width;
            icon: "\uE819";
            text: qsTr("Change user");
            description: qsTr("Choose user to login as");
            onClicked: activestack.push(changeuser);
            with_seperator: false;
            icon_color: lkpalette.menuItemIcon1
            icon_bk_color: lkpalette.menuItemBackground1
        }
        LKMenuItem{
            height: 85;
            width: parent.width;
            icon: "\uE819";
            text: qsTr("Change back");
            description: qsTr("Back to your own account");
            visible: credentials.token != http.token;
            onClicked: {
                http.set_authentication_token(credentials.token);
                lkinterface.user.req_userinfo(change_user_cb);
            }
            with_seperator: false;
            icon_color: lkpalette.menuItemIcon2
            icon_bk_color: lkpalette.menuItemBackground2
        }
        LKMenuItem{
            height: 85;
            width: parent.width;
            icon: "\uE819";
            text: qsTr("Orders");
            description: qsTr("Show all orders");
            onClicked: {
                activestack.push(admin_orders_view);
            }
            with_seperator: false;
            icon_color: lkpalette.menuItemIcon2
            icon_bk_color: lkpalette.menuItemBackground2
        }
    }


    Component{
        id: changeuser;

        Item{
            property var picked: undefined;

            function change_usertoken_cb(ok, retval){
                if(!ok) return;
                if('access_token' in retval){
                    http.set_authentication_token(retval['access_token']);
                    lkinterface.user.req_userinfo(change_user_cb);
                }
            }

            function update_users_list_cb(ok, userslist){
                if(!ok) return;
                for(let i=0; i<userslist.length; i++){
                    users.append({'name': userslist[i]});
                }
            }


            ListModel{
                id: users;
            }

            LKListview{
                id: lw;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.top: parent.top;
                anchors.bottom: change_user_submit.top;

                property int selectedidx: -1;
                model: users;
                //spacing: 15;
                delegate: Item{
                    height: 45;
                    width: lw.width;
                    LKLabel{
                        text: propData.name;
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                onItem_clicked: function(index){
                    picked = lw.model.get(index).name;
                    lw.currentIndex = index;
                }
                Component.onCompleted: {
                    lkinterface.admin.req_users_list(update_users_list_cb);
                }

                highlight: Rectangle{
                    color: "transparent"
                    radius: 5;
                    border.width: 2;
                    border.color: lkpalette.signalgreen;
                    z: 10;
                }

            }
            LKButtonV2{
                id: change_user_submit;
                anchors.bottom: parent.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                text: qsTr("Change");
                height: 50;
                enabled: picked != undefined
                onClicked: {
                    lkinterface.admin.change_to_user(picked, change_usertoken_cb)
                }
            }
        }
    }

    Component{
        id: admin_orders_view;
        AdminOrdersView{
            property string headertext: qsTr("ALL ORDERS")
        }
    }

    Component.onCompleted: header.headText = qsTr("ADMIN")
}
