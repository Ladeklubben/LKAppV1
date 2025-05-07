import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtQuick 2.15

Item {

    signal cancel;
    signal ok;

    function req_register(json){

        http.post('/user/register', json, function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    credentials.email = inputEmail.text;
                    credentials.password = Qt.md5(inputPass.text);
                    ok();
                }
                else if(o.status === 400){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Missing paramters")});
                }
                else if(o.status === 200){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("Already a member")});
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

    ScrollView {
        id: scrollview
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: buttonShelf.top;

        ColumnLayout{
            anchors.fill: parent;
            spacing: 20;
            anchors.margins: 20;

            LKTextEdit2{
                id: inputEmail;
                property bool ok: false;
                inputMethodHints: Qt.ImhLowercaseOnly | Qt.ImhEmailCharactersOnly;
                headline: qsTr("Email")
                font.capitalization: Font.AllLowercase;
                validator: RegularExpressionValidator { regularExpression:/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }
                KeyNavigation.down: inputName;
                KeyNavigation.tab: inputName;
            }
            LKTextEdit2{
                id: inputName;
                headline: qsTr("Name")
                KeyNavigation.up: inputEmail;
                KeyNavigation.down: inputAddr;
                KeyNavigation.tab: inputAddr;
            }
            LKTextEdit2{
                id: inputAddr;
                headline: qsTr("Address")
                KeyNavigation.up: inputName;
                KeyNavigation.down: inputCity;
                KeyNavigation.tab: inputCity;
            }
            LKTextEdit2{
                id: inputCity;
                headline: qsTr("City")
                KeyNavigation.up: inputAddr;
                KeyNavigation.down: inputZip;
                KeyNavigation.tab: inputZip;
            }
            LKTextEdit2{
                id: inputZip;
                headline: qsTr("Zip")
                inputMethodHints: Qt.ImhPreferNumbers;
                KeyNavigation.up: inputCity;
                KeyNavigation.down: inputPass;
                KeyNavigation.tab: inputPass;
            }
            LKTextEdit2{
                id: inputPass;
                echoMode: TextInput.Password ;
                headline: qsTr("Password")
                validator: RegularExpressionValidator {
                    regularExpression: /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{6,}).*/
                }
                onTextEdited: {
                    if(!acceptableInput)
                        errlabel.text = msg_password_requirement
                    else{
                        errlabel.text = "";
                    }
                }
                KeyNavigation.up: inputZip;
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

            function pickNext(){
                for (var i = 0; i < children.length - 2; ++i){
                    if(children[i].hasFocus){
                        children[i].hasFocus = false;
                        children[i+1].hasFocus = true;
                        break;
                    }
                }
            }
            Keys.onTabPressed: pickNext();
            Keys.onEnterPressed: pickNext();
            Keys.onReturnPressed: pickNext();
        }
    }   

    ButtonShelf {
        id: buttonShelf
        firstButtonText: qsTr("Register")
        secondButtonText: qsTr("Cancel")
        onFirstButtonPressed: registerCheck()
        onSecondButtonPressed: loginhandler.pop()

        function registerCheck(){
            var err = false;
            if(!inputEmail.acceptableInput){
                err = true;
                inputEmail.indicate_error = true;
            }else inputEmail.indicate_error = false;

            if(!inputName.acceptableInput || inputName.text === ""){
                err = true;
                inputName.indicate_error = true;
            }else inputName.indicate_error = false;

            if(!inputAddr.acceptableInput || inputAddr.text === ""){
                err = true;
                inputAddr.indicate_error = true;
            }
            else inputAddr.indicate_error = false;

            if(!inputCity.acceptableInput || inputCity.text  === ""){
                err = true;
                inputCity.indicate_error = true;
            }
            else inputCity.indicate_error = false;

            if(!inputZip.acceptableInput || inputZip.text === ""){
                err = true;
                inputZip.indicate_error = true;
            }
            else inputZip.indicate_error = false;

            if(!inputPass.acceptableInput || inputPass.text === ""){
                err = true;
                inputPass.indicate_error = true;
            }
            else inputPass.indicate_error = false;

            if(err){
                errlabel.text = qsTr("Please fix the marked fields")
                return;
            }

            var obj = {
                email: inputEmail.text,
                name: inputName.text,
                street: inputAddr.text,
                city: inputCity.text,
                zip: inputZip.text,
                password: Qt.md5(inputPass.text),
            };
            var json = JSON.stringify(obj);
            req_register(json);
        }
    }
}
