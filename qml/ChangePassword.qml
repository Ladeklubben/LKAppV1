import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtQuick 2.15

Item {
    property string email;

    signal ok;

    function changePassword(email, password){
        http.put('/user/set_new_password', JSON.stringify({'email': email, 'password': password}), function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    credentials.email = email;
                    credentials.password = password;
                    ok();
                }
                else if(o.status === 403) {
                    errlabel.text = qsTr("Unable to set new password - please contact support");
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

    ColumnLayout{
        spacing: 25;
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
            bottom: buttonShelf.top;
            margins: 20;
            topMargin: 50;
        }

        Text {
            id: headline
            text: qsTr("Change Password")
            color: lkpalette.base_white;
            Layout.fillWidth: true;
            font.pointSize: 30;
            font.bold: true;
            wrapMode: Text.WordWrap;
        }

        Text {
            id: text
            text: qsTr("You can now enter a new password. Please make sure to use a secure password.")
            color: lkpalette.base_white;
            Layout.fillWidth: true;
            font.pointSize: 14;
            wrapMode: Text.WordWrap;
        }

        LKTextEdit2{
            id: password1;
            property bool ok: false;
            Layout.topMargin: 20;
            headline: qsTr("New password")
            echoMode: TextInput.PasswordEchoOnEdit;
            passwordMaskDelay: 100;
            validator: RegularExpressionValidator {
                regularExpression: /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{6,}).*/
            }
            onTextEdited: {
                indicate_error = !acceptableInput;
            }

            onAcceptableInputChanged: {
                if(!acceptableInput)
                    errlabel.text = msg_password_requirement
                else
                    errlabel.text = "";
            }
            KeyNavigation.down: password2;
            KeyNavigation.tab: password2;
        }

        LKTextEdit2{
            id: password2;
            property bool ok: false;
            Layout.topMargin: -5;
            headline: qsTr("Confirm password")
            echoMode: TextInput.PasswordEchoOnEdit;
            KeyNavigation.up: password1;
            KeyNavigation.tab: password1;
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
                font.pointSize: 14;
                font.italic: true;
                wrapMode: Text.WordWrap;
                horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;
                padding: 20;
            }
        }
    }
    Component.onCompleted: {
    }

    ButtonShelf {
        id: buttonShelf
        firstButtonText: qsTr("Change Password")
        secondButtonText: qsTr("Cancel")
        onFirstButtonPressed: submitCheck()
        onSecondButtonPressed: loginhandler.pop()

        function submitCheck() {
            if(!password1.acceptableInput){
                password1.indicate_error = true;
                errlabel.text = msg_password_requirement
            }
            else if(password1.text !== password2.text){
                errlabel.text = qsTr("You did not correctly confirm the password");
                password2.indicate_error = true;
            }
            else if(password1.acceptableInput){
                changePassword(email, Qt.md5(password1.text))
            }
            else{
                errlabel.text = msg_password_requirement
            }
        }
    }
}
