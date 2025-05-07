import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtQuick

Item{
    id: login
    property bool request_guest_login: false;

    signal done(var info);
    signal backButton();


    property string email: "";
    property string password: "";

    property string msg_password_requirement: qsTr("Password need to be minimum 6 characters, 1 upper case, 1 lower case and 1 digit");

    function req_userinfo(){
        http.request("/user/information", "",
                    function (o) {
                        if(o.readyState === XMLHttpRequest.DONE){
                            if(o.status === 200) {
                                var retval = JSON.parse(o.responseText);
                                done(retval);
                            }
                            else if(o.status === 0) {
                                alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                            }
                            else{
                                alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                            }
                        }
                    });
    }

    function req_login(){
        http.post_login('/user/login', JSON.stringify({
                                                          "email": email,
                                                          "password": password,
                                                      }), function (o) {
                                                          if(o.readyState === XMLHttpRequest.DONE){
                                                              if(o.status === 200) {
                                                                  var retval = JSON.parse(o.responseText);
                                                                  if('access_token' in retval){
                                                                      credentials.token = retval['access_token']; //Store the access token for all furture requests
                                                                      credentials.expirationtime = retval['expires'];
                                                                      lkinterface.user.req_userinfo(function(ok, userinfo){
                                                                        if(ok) done(userinfo);
                                                                      });
                                                                  }
                                                                  else{
                                                                      alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Login error")});
                                                                  }
                                                              }
                                                              else if(o.status === 404){
                                                                  alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Invalid password")});
                                                              }
                                                              else if(o.status === 0) {
                                                                  alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                                                              }
                                                              else{
                                                                  alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                                                              }
                                                          }
                                                      });
    }

    function req_guest_login() {
        http.post_login('/anonymous_login', "", function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    var retval = JSON.parse(o.responseText);
                    if('access_token' in retval){
                        credentials.token = retval['access_token']; //Store the access token for all furture requests
                        req_userinfo();
                    }
                    else{
                        alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Login error")});
                    }
                }
                else if(o.status === 404){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Invalid password")});
                }
                else if(o.status === 0) {
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });
    }

    LKStackView{
        id: loginhandler;
        anchors.fill: parent;
        anchors.margins: 0;


        Connections {
            target: alertbox.item
            function onOk(){
                loginhandler.replace(logininput);
            }
        }

        Component {
            id: doLogin
            Item {
                Label{
                    id: busytxt
                    anchors.centerIn: parent;
                    text: qsTr("Logging in...")
                    color: "white"
                }

                LoadingSpinner{
                    anchors.bottom: busytxt.top;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.bottomMargin: 30;
                }

                Component.onCompleted: {
                    req_login();
                }
            }
        }

        Component {
            id: doGuestLogin;
            Item {
                Label{
                    id: busytxt
                    anchors.centerIn: parent;
                    text: qsTr("Logging in as guest...")
                    color: "white"
                }

                LoadingSpinner{
                    anchors.bottom: busytxt.top;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.bottomMargin: 30;
                }

                Component.onCompleted: {
                    req_guest_login();
                }
            }

        }
        Component {
            id: logininput
            Item {
                property string headertext: qsTr("LOGIN");

                function request_login(){
                    var err = false;

                    if(!inputEmail.acceptableInput || inputEmail.text === ""){
                        inputEmail.indicate_error = true;
                        err = true;
                    }
                    else inputEmail.indicate_error = false;

                    if(inputPass.text === ""){
                        inputPass.indicate_error = true;
                        err = true;
                    }
                    else inputPass.indicate_error = false;

                    if(err){
                        errlabel.text = "";
                        return;
                    }
                    else errlabel.text = "";

                    activeCharger.id = "";
                    credentials.appid = -1;
                    credentials.email = inputEmail.text.toLowerCase();
                    credentials.password = Qt.md5(inputPass.text);
                    loginhandler.replace(doLogin);
                }

                function request_guest_login(){
                    console.log("Guest login");
                    activeCharger.id = "";
                    credentials.appid = -1;
                    credentials.email = "";
                    loginhandler.replace(doGuestLogin);
                }

                
                Image{
                    id: login_image;
                    source: "qrc:/icons/login_image.jpg";
                    anchors.top: parent.top;
                    anchors.topMargin: - parent.width * 0.3;
                    width: parent.width;
                    height: 250 + parent.width * 0.3;
                    fillMode: Image.PreserveAspectCrop;    
                
                }

                Rectangle{
                    id: sideBarBack
                    anchors.top: parent.top;
                    anchors.left: parent.left;
                    anchors.margins: 30
                    height: 60
                    width: 60
                    radius: 200
                    color: lkpalette.base
                    MouseArea {
                        id: clickableArea
                        anchors.fill: parent
                        onClicked: {
                            backButton();
                        }
                    }
                    LKIcon{
                        anchors.centerIn: parent;
                        anchors.horizontalCenterOffset: -3
                        anchors.verticalCenterOffset: 1
                        font.pointSize: 20;
                        color: lkpalette.base_white;
                        text: "\uE822";
                    }
                }

                ColumnLayout{
                    anchors.top: login_image.bottom;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    anchors.bottom: loginShelf.top;
                    spacing: 20;
                    anchors.margins: 30

                    LKTextEdit2{
                        id: inputEmail;
                        headline: qsTr("Email");
                        text: credentials.email;
                        inputMethodHints: Qt.ImhLowercaseOnly | Qt.ImhEmailCharactersOnly;
                        validator: RegularExpressionValidator { regularExpression:/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }
                        font.capitalization: Font.AllLowercase;

                        KeyNavigation.down: inputPass;
                        KeyNavigation.tab: inputPass;
                        Keys.onEnterPressed: inputPass.focus = true;
                        Keys.onReturnPressed: inputPass.focus = true;
                    }
                    LKTextEdit2{
                        id: inputPass;
                        headline: qsTr("Password");
                        echoMode: TextInput.Password ;

                        KeyNavigation.up: inputEmail;
                        KeyNavigation.tab: inputEmail;
                        Keys.onEnterPressed: request_login();
                        Keys.onReturnPressed: request_login();
                    }

                    RowLayout {
                        width: parent.width
                        Layout.leftMargin: 20
                        Layout.rightMargin: 20

                        Text {
                            id: forgotPasswordText
                            text: qsTr("Forgot password")
                            color: lkpalette.signalgreen
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                function req_password_reset(email){
                                    http.put('/user/reset_password', JSON.stringify({'email': email}), function (o) {
                                        if(o.readyState === XMLHttpRequest.DONE){
                                            if(o.status === 200) {
                                                loginhandler.push(validate_code, {email: email});
                                            }
                                            else if(o.status === 429){
                                                alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Too many retries, wait a few seconds")});
                                            }
                                            else if(o.status === 0) {
                                                alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Network error")});
                                            }
                                            else{
                                                alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                                            }
                                        }
                                    });
                                }

                                onClicked: {
                                    var err = false;

                                    if(!inputEmail.acceptableInput || inputEmail.text === ""){
                                        inputEmail.indicate_error = true;
                                        err = true;
                                    }
                                    else inputEmail.indicate_error = false;

                                    if(err){
                                        errlabel.text = qsTr("Please enter an email address");
                                        return;
                                    }
                                    else errlabel.text = "";
                                    req_password_reset(inputEmail.text.toLocaleLowerCase());
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Text {
                            id: continueAsGuestText
                            text: qsTr("Continue as guest")
                            color: lkpalette.signalgreen;
                            horizontalAlignment: Text.AlignRight
                            Layout.alignment: Qt.AlignRight

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    request_guest_login();
                                }
                            }
                        }
                    }


                    Item{
                        id: errtext;
                        Layout.preferredHeight: 100;
                        Layout.fillHeight: true;
                        Layout.fillWidth: true;

                        Text{
                            id: errlabel;
                            anchors.fill: parent;
                            color: lkpalette.text;
                            font.pointSize: 16;
                            font.italic: true;
                            wrapMode: Text.WordWrap;
                            horizontalAlignment: Text.AlignHCenter;
                            verticalAlignment: Text.AlignVCenter;
                            padding: 20;
                        }
                    }
                }
                

                ButtonShelf {
                    id: loginShelf;
                    firstButtonText : qsTr("Login");
                    secondButtonText: qsTr("Register");
                    onFirstButtonPressed: {
                        onClicked: request_login();
                    }
                    onSecondButtonPressed: {
                        onClicked: loginhandler.push(regnew);
                    }
                }
            }
        }

        Component{
            id: regnew
            Register{
                property string headertext: qsTr("REGISTER");
                onCancel: loginhandler.pop();
                onOk: {
                    loginhandler.clear();
                    loginhandler.push(doLogin);
                }
            }
        }

        Component{
            id: validate_code
            IdentityValidator{
                onOk: loginhandler.replace(change_password, {email: email} )
            }
        }

        Component{
            id: change_password
            ChangePassword{
                onOk: {
                    loginhandler.clear();
                    loginhandler.push(doLogin);
                }
            }
        }

        Component.onCompleted: {
            loggedin = false;

            if(request_guest_login){
                push(doGuestLogin);
                return;
            }

            if(password != "" && email != ""){
                push(doLogin);
            }
            else{
                //Go to the login screen
                activestack = this;
                push(logininput);
            }
        }
    }
}
