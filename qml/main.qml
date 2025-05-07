pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import PushNotification 1.0
import QtCore

Window {
    id: root

    visible: true
    width: 433
    height: 900

    color: lkpalette.base;
    title: qsTr("Ladeklubben")

    property bool loggedin: false;
    property var activestack: rootstack;
    property var last_activestack: undefined;
    property bool showMenuBar: true;
    property bool showHeader: showMenuBar === false;
    property bool settingsPageOpen: false
    property string selectedPage: "map"

    property int activestate;   //represent the latest state of the app - suspended, idle, active etc.

    onLoggedinChanged: {
        if(!loggedin){
            //TODO: Clean up old data
        }
    }

    /* When the base page is reached, it needs
       two back-pressed before we exit on mobile
    */
    property double closetime: 0;

    onClosing: function(close){
        var now = Date.now();

        if (Qt.platform.os === "android")
        {
            if(header.atBase){
                if((now - closetime) < 1000){
                    close.accepted = true
                    return;
                }
                closetime = now;
            }
            close.accepted = false;
        }
    }

    FontLoader {
        id: lkfonts;
        source: "../fonts/fontello.ttf"
    }


    QtObject{
        id: lkpalette;

        property color base: "#2e4d59";
        property color base_dark: "#4B909C";
        property color base_extra_dark: "#183A47"
        property color base_light: "#e8eef0";   //Used for light backgrounds - close to white
        property color base_white: "white";
        property color base_grey: "#a4b2b7";
        property color button: "#6d7b6c";
        property color buttonDown: "#a1afa0";
        property color buttonDisabled: "#888f88"
        property color border: "white";
        property color buttonText: "white"
        property color buttonTextDisabled: "darkgrey"
        property color text: "white";
        property color text_dimmed: "#a1afa0";
        property color seperator: "#a1afa0";
        property color signalgreen: "#5cf628"
        property color g_discount: "#188cf0"
        property color g_free: signalgreen;
        property color g_flat: "#ce3cf2";
        property color g_button_bg: "white"
        property color g_page_bg: "#ebf0f2"
        property color error: "red";

        // Menu Items
        property color menuItemDescription: "#7DA2B0";
        property color menuWarningBackground: "#47181B";

        property color menuItemBackground1: "#91F18F";
        property color menuItemBackground2: "#8FD4F1";
        property color menuItemBackground3: "#B48FF1";
        property color menuItemBackground4: "#5A70BF";
        property color menuItemBackground5: "#F18FBE";
        property color menuItemBackground6: "#CD617B";
        property color menuItemBackground7: "#EFF18F";
        property color menuItemBackground8: "#F1B28F";

        property color menuItemIcon1: "#0D8A0B";
        property color menuItemIcon2: "#0A709B";
        property color menuItemIcon3: "#491899";
        property color menuItemIcon4: "#09278F";
        property color menuItemIcon5: "#9D0E53";
        property color menuItemIcon6: "#880F2C";
        property color menuItemIcon7: "#9C9F0B";
        property color menuItemIcon8: "#924216";

    }
    QtObject{
        id:lkfont;
        property int sizeSmall: 10;
        property int sizeMediumSmall: 14;
        property int sizeNormal: 16;
        property int sizeLarge: 24;
        property int sizeLarger: 36;
        property int sizeVeryLarge: 48;
    }

    OwnerGroups{
        id: ownergroups;
    }

    GuestGroups{
        id: guestgroups;
    }

    Settings {
        property alias x: root.x
        property alias y: root.y
        property alias width: root.width
        property alias height: root.height
    }

    Settings {
        id: credentials;
        category: "Credentials"
        property string email: "";
        property string password: "";
        property int appid: -1;
        property string token: "";
        property int expirationtime: -1;

        onTokenChanged: {
            http.set_authentication_token(token);
        }

        Component.onCompleted: {
            root.activestack = rootstack;
            if(email === "" || password === ""){
                root.activestack.push(mapstack);
            }
            else {
                root.activestack.push(loginstack);
            }
        }
        onAppidChanged: {
            console.log("appid changed:", appid);
        }
    }
    Settings {
        id: activeCharger;
        category: "ActiveCharger";
        property string id: "";
    }

    Settings {
        id: maplocation
        category: "Map";
        property var last_center;
    }

    property string serveraddr: "https://restapi.ladeklubben.dk"
    //property string serveraddr: "http://172.31.1.56:5000"
    //property string serveraddr: "http://127.0.0.1:5000"
    property var userinfo;
    property string name: "";
    property var ownergroups;
    property var payment;
    property var member_role;               //Is member admin?
    property Item active_app_section;    //Defines the active Item
    property Item lastStationItem;

    property var stations: [];
    property int stationsCount: 0

    onStationsCountChanged: {
        if(stationsCount == 0){
            if(selectedPage == 'charger'){
                selectedPage = "map";
                bottommenu.showPage(mapstack);
            }
        }
    }


    Http{
        id: http;
    }

    LKInterface{
        id: lkinterface;
    }

    DateTime{   //Helpers for formatting dates and times correctly
        id: datetime;
    }

    QR{
        id: qrtools;
    }

    OpeningHours{
        id: openening_strings;
    }


    HeaderBar{
        id: header;
        anchors.top: parent.top
        width: parent.width;
        height: 65;
        visible: root.showHeader;
    }

    LKStackView {
        id: rootstack
        anchors.top: root.showHeader ? header.bottom : parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: root.showMenuBar ? bottommenu.top : parent.bottom;

        function handle_after_login(){
            rootstack.replace(mapstack);
            root.selectedPage = "map";
        }

        Component{
            id:loginstack
            Loginpage{
                password: credentials.password;
                email: credentials.email;

                property var after_login_do: rootstack.handle_after_login;
                onBackButton: {
                    rootstack.replace(mapstack);
                    root.selectedPage = "map";
                }

                onDone: function(info){
                    userinfo = info['userinfo'];
                    member_role = userinfo['role'];
                    loggedin = true;
                    //console.log("Logged in!", userinfo['name'], JSON.stringify(info));
                    ownergroups.data = info.groups;
                    guestgroups.data = info.guestgroups;
                    guestgroups.pending_invites = info.group_invites;


                    payment = info.payment;

                    stations = info.stations;
                    stationsCount = stations.length;

                    after_login_do();

                    if(guestgroups.pending_invites.length > 0){
                        activestack.push(group_invites);
                    }
                    //Used for testing a widget);

                    //rootstack.push(testwidget);
                }
            }
        }



        Component{
            id: station_swipeview;

            Item{
                id: station_swipeview_item
                property string headertext: "";

                Item{
                    id: stationHeader;
                    property string text: "";
                    property bool isMultiCharger: false;
                    property var add_station: stationslist.add_station;

                    anchors{
                        top: parent.top;
                        left: parent.left;
                        right: parent.right;
                    }
                    height: header.height;

                    LKLabel{
                        text: stationHeader.text;
                        anchors.centerIn: parent;
                        font.pointSize: lkfont.sizeNormal;
                        font.bold: true
                    }

                    LKIconButton{
                        anchors{
                            verticalCenter: parent.verticalCenter;
                            right: parent.right;
                            margins: 20;
                        }

                        /*
                            + = "\uE825"  //Only one charger
                            Ned = "\uE821"    //List closed
                            Op = "\uE824"   //List open
                        */

                        text: stationHeader.isMultiCharger ? stations_dropdown.visible ? "\uE824" : "\uE821" : "\uE825";
                        pointsize: 30;
                        width: 30;
                        height: 30;
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                        visible: stationHeader.isMultiCharger;
                        onClicked: {
                            stations_dropdown.visible = !stations_dropdown.visible;
                        }
                    }
                }

                MouseArea{
                    id: stations_dropdown;

                    visible: false;
                    z: 10;
                    anchors {
                        top: stationHeader.bottom;
                        left: parent.left;
                        right: parent.right;
                        bottom: parent.bottom;
                    }

                    Rectangle{
                        anchors.fill: parent;
                        color: lkpalette.base
                        opacity: 0.80;
                    }

                    LKStationListView{
                        id: stationslist;
                        anchors.fill: parent;
                        anchors.margins: 20;

                        function change_station(idx){
                            station_swipeview_control.currentIndex = idx;
                            stations_dropdown.visible = false;
                        }
                    }
                }

                SwipeView{
                    id: station_swipeview_control

                    anchors{
                        left:  parent.left;
                        right: parent.right;
                        top: stationHeader.bottom;
                        bottom: pageindicator.top;
                    }

                    interactive: true;

                    Component.onCompleted: {
                        if(root.stations == undefined) return;

                        var active_idx = -1;
                        var id = activeCharger.id;

                        for( var i = 0; i < root.stations.length; i++){
                            var page = stationobj.createObject(parent,
                                {
                                    stationdata: stations[i],
                                });
                            //Insert stationobj into this swipeview
                            insertItem(i, page);

                            //Update the dropdown list.
                            stationHeader.add_station(i, page);

                            //Pick the last one, so that you dont have to search if you leave the page
                            if(stations[i].id === id){
                                active_idx = i;
                            }
                        }
                        if(active_idx !== -1){
                            setCurrentIndex(active_idx);
                        }
                        stationHeader.isMultiCharger = stations.length > 1;
                        if(stations.length > 1){
                            pageindicator.visible = true;
                        }
                    }
                    onCurrentIndexChanged: {
                        let station = currentItem as StationPage
                        if (station) {
                            activeCharger.id = station.stationid
                            let headerstring = station.stationid;
                            if("brief" in station.stationinfo){
                                headerstring += " - " + station.stationinfo.brief;
                            }
                            stationHeader.text = headerstring;
                        }
                    }
                }

                Item{
                    id: pageindicator;
                    height: 20;
                    visible: true;
                    anchors{
                        bottom:  parent.bottom;
                        left:    parent.left;
                        right:   parent.right;
                        margins: 5;
                    }

                    PageIndicator {
                        id: indicator
                        count: station_swipeview_control.count
                        currentIndex: station_swipeview_control.currentIndex
                        anchors{
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.bottom;
                        }
                    }
                }
            }
        }

        Component{
            id: stationobj;
            StationPage{
                property var status;
                property var stationdata;
                stationid: stationdata.id;
                stationinfo: stationdata.location;
                stationtype: stationdata.type;
                property bool isOnline: readings.connection_state;

                Measurement{
                    id: readings;
                }

                enabled: SwipeView.isCurrentItem;
            }
        }

        Component{
            id: mapstack;
            MapPage{
                Component.onCompleted: {
                    laststack = rootstack;
                }
            }
        }

        /* The profile view will use whatever stack is active to
           show its content. The benefit of this is, that when we
           want to go back, we will end on the same root page as
           what we used beforehand
        */
        Component {
            id: menuView
            LKStackView{
                initialItem: MenuPage{}
                Component.onCompleted: {
                    root.activestack.laststack = rootstack;
                }
            }
        }

        Component{
            id: electricity_prices_page
            LKStackView{
                initialItem: Spotprices{}
                Component.onCompleted: {
                    laststack = rootstack;
                }
            }
        }

        Component{
            id: group_invites
            GroupInvitesNotification{
            }
        }

        Component{
            id: testwidget;
            Mainmeter{

            }
        }

        Component{
            id: adminpage;
            Adminpage{

            }
        }
    }

    BottomMenu {
        id: bottommenu;
        anchors.bottom: parent.bottom;
        width: parent.width;
        height: root.height * 0.1;
    }

    Loader{
        id: alertbox;
        anchors.fill: parent;
    }


    PushNotification{
        id: push;
        enable: loggedin;
        function update_data_extra(){
            if(active_app_section.push_subscribe_cmd === "updMap" ){
                push.data_extra = {'subscribe': "updMap", 'lastupdate': active_app_section.last_map_update}
                forceUpdate();
            }
            else{
                push.data_extra = {'subscribe': "updMeas"}
            }
        }

        onMessageReceived: function(msg){
            var js= JSON.parse(msg);

            if(!('msgtype' in js))
                return;

            if('msgtype' === "updMem"){
                return;
            }
            if(root.active_app_section != null){
                root.active_app_section.push_update = js;
                update_data_extra();
            }
        }

        Component.onCompleted: {
            appid = credentials.appid;
            clientid = credentials.email;
            data_extra = {'subscribe': "updMap", 'lastupdate': -1};
        }
        onAppidChanged: function(appid){
            credentials.appid = appid;
        }
    }

    onActive_app_sectionChanged: {
        if(active_app_section == null) return;
        push.update_data_extra();
        if(active_app_section.push_subscribe_cmd !== "updMap")
            push.forceUpdate();
    }

    function refresh_token_cb(ok, retval){
        if(ok){
            refreshTimer.restart();

            console.log("refresh_token_cb", JSON.stringify(retval));
            credentials.token = retval['access_token'];
            credentials.expirationtime = retval['expires'];
        }
    }

    function handle_token_refresh() {
        refreshTimer.restart();

        let currentEpoch = Math.floor(Date.now() / 1000)  // Current time in seconds
        let timeUntilExpiry = credentials.expirationtime - currentEpoch

        console.log("Expires in", timeUntilExpiry, "Seconds");
        if(!root.loggedin) return;
        if(timeUntilExpiry < 5*60){
            console.log("Token expires in", timeUntilExpiry, "Seconds. Relogin");
            //startover and Relogin
            root.activestack = rootstack;
            root.activestack.clear();
            root.activestack.push(loginstack);
        }
        else if(timeUntilExpiry < (12 * 60 * 60)){
            console.log("Token expires in", timeUntilExpiry, "Seconds. Refresh");
            lkinterface.user.req_token_refresh(refresh_token_cb);
        }
    }

    Timer {
        id: refreshTimer
        interval: 60 * 1000  // Check every minute
        repeat: true
        running: root.loggedin
        onTriggered: {
            root.handle_token_refresh();
        }
    }


    Connections {
        target: Qt.application
        function onStateChanged(state){
            if(state == Qt.ApplicationActive){
                root.handle_token_refresh();
            }
            root.activestate = state;
        }
    }
}
