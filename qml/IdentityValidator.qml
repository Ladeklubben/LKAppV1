import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtQuick 2.15

Item {
    property string email;

    signal cancel;
    signal ok;

    function validateCode(code){
        http.put('/user/validate_password_code', JSON.stringify({'email': email, 'code': code}), function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    ok();
                }
                else if(o.status === 422){
                    var js = JSON.parse(o.responseText);
                    if(js.detail.left > 0){
                        errlabel.text = qsTr("You entered a wrong code - you have %1 tries left").arg(js.detail.left);
                    }
                    else{
                        errlabel.text = qsTr("You entered the code wrong too many times");
                        submit_but.enabled = false;
                    }
                    //alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});

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
            margins: 30;
            topMargin: 50;
        }

        Text {
            id: headline
            text: qsTr("Password Reset Email Sent")
            color: lkpalette.base_white;
            Layout.fillWidth: true;
            font.pointSize: 30;
            font.bold: true;
            wrapMode: Text.WordWrap;
        }

        Text {
            id: text
            text: qsTr("You can change your password after you have entered the 5-digit validation code.")
            color: lkpalette.base_white;
            Layout.fillWidth: true;
            font.pointSize: 14;
            wrapMode: Text.WordWrap;
        }

        LKTextEdit2{
            id: inputCode;
            property bool ok: false;
            inputMethodHints: Qt.ImhPreferNumbers;
            Layout.topMargin: 20;
            headline: qsTr("Validation code")
            validator: IntValidator{
                bottom: 0;
                top: 99999;
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
                font.pointSize: 14;
                font.italic: true;
                wrapMode: Text.WordWrap;
                horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;
                padding: 20;
            }
        }
    }
    ButtonShelf {
        id: buttonShelf
        firstButtonText: qsTr("Submit")
        secondButtonText: qsTr("Cancel")
        onFirstButtonPressed: submitCheck()
        onSecondButtonPressed: loginhandler.pop()

        function submitCheck() {
            try{
                if(inputCode.acceptableInput){
                    inputCode.indicate_error = false;
                    validateCode(parseInt(inputCode.text));
                }
                else{
                    errlabel.text = qsTr("The code you entered is not valid");
                    inputCode.indicate_error = true;
                }
            }catch(error){
                console.log("Error submitting:", error)
                inputCode.indicate_error = true;
            }
        }
    }
}
