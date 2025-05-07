import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtLocation

Item {
    Component.onCompleted: {
        header.headText = qsTr("Edit information")
        header.subtext = user.email
        businessCheck.checked = 'companyName' in user ? user['companyName'] !== '' ? true : false : false;
    }

    property string name:        ""
    property string email:       ""
    property string street:      ""
    property string zip:         ""
    property string city:        ""
    property string bankAccount: ""
    property string nationalID:  ""
    property bool isBusiness: false

    function updateCheck(){
        var err = false;
        var isBusiness = businessCheck.checkState
        if(!inputCompanyName.acceptableInput){
            err = true;
            inputCompanyName.indicate_error = true;
        }else inputCompanyName.indicate_error = false;

        if(!inputName.acceptableInput || inputName.text === ""){
            err = true;
            inputName.indicate_error = true;
        }else inputName.indicate_error = false;

        if(!inputStreet.acceptableInput || inputStreet.text === ""){
            err = true;
            inputStreet.indicate_error = true;
        }else inputStreet.indicate_error = false;

        if(!inputCity.acceptableInput || inputCity.text  === ""){
            err = true;
            inputCity.indicate_error = true;
        }else inputCity.indicate_error = false;

        if(!inputZip.acceptableInput || inputZip.text === ""){
            err = true;
            inputZip.indicate_error = true;
        }else inputZip.indicate_error = false;

        if(!inputBankAccount.acceptableInput){
            err = true
            inputBankAccount.indicate_error = true
        }else inputBankAccount.indicate_error = false

        if(isBusiness){
            if(!inputCompanyName.acceptableInput ||  inputCompanyName.text === ""){
                err = true;
                inputCompanyName.indicate_error = true;
            }
            if(!inputCompanyID.acceptableInput){
                err = true
                inputCompanyID.indicate_error = true
            }else inputCompanyID.indicate_error = false
        }
        else{
            inputCompanyID.text = "";
            inputCompanyName.text = "";
        }

        if(err){
            errlabel.text = qsTr("Please fix the marked fields")
            return;
        }
        var obj
        //if(isBusiness)
        {
            obj = {
                name: inputName.text,
                street: inputStreet.text,
                city: inputCity.text,
                zip: inputZip.text,
                //isBusiness: isBusiness,
                companyName: inputCompanyName.text,
                bankAccount: inputBankAccount.text,
                companyID: inputCompanyID.text
            };
        }
        // else {
        //     obj = {
        //         name: inputName.text,
        //         street: inputStreet.text,
        //         city: inputCity.text,
        //         zip: inputZip.text,
        //     }
        // }


        var json = JSON.stringify(obj);
        console.log(json)
        lkinterface.user.updateUser(json);
    }

    Flickable {
        id: flickable
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: buttonShelf.top
        contentWidth: width
        contentHeight: contentColumn.implicitHeight
        clip: true

        ScrollBar.vertical: LKScrollBar {
            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
        }

        ColumnLayout {
            id: contentColumn
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            anchors.margins: 20
            spacing: 20
            width: flickable.width - 40

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Math.max(businessLabel.height, businessCheck.height)

                LKLabel {
                    id: businessLabel
                    text: qsTr("Business")
                    anchors.left: parent.left
                    anchors.margins: 20
                    anchors.verticalCenter: parent.verticalCenter
                }

                LKCheckbox {
                    id: businessCheck
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            LKTextEdit2 {
                id: inputCompanyName
                headline: qsTr("Company Name")
                visible: businessCheck.checkState
                text: 'companyName' in user ? user.companyName : ''
                Layout.fillWidth: true
            }

            LKTextEdit2 {
                id: inputName
                headline: qsTr("Name")
                text: user.name
                Layout.fillWidth: true
            }

            LKTextEdit2 {
                id: inputStreet
                headline: qsTr("Address")
                text: user.street
                Layout.fillWidth: true
            }

            LKTextEdit2 {
                id: inputCity
                headline: qsTr("City")
                text: user.city
                Layout.fillWidth: true
            }

            LKTextEdit2 {
                id: inputZip
                headline: qsTr("Zip")
                text: user.zip
                Layout.fillWidth: true
            }

            LKTextEdit2 {
                id: inputBankAccount
                headline: qsTr("Bank Account")
                text: 'bankAccount' in user ? user.bankAccount : ''
                Layout.fillWidth: true
                //validator: RegularExpressionValidator{ regularExpression: /^\d{4}-?\d{1,10}$/ }
            }

            LKTextEdit2 {
                id: inputCompanyID
                headline: qsTr("Company ID")
                text: 'companyID' in user ? user.companyID : ''
                visible: businessCheck.checkState
                Layout.fillWidth: true
                //validator: RegularExpressionValidator { regularExpression: /?[0-9]{8}/ }
            }

            Item{
                id: errtext;
                Layout.fillWidth: true;
                Layout.preferredHeight: errlabel.height > 0 ? errlabel.height + 40 : 0

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

            // To get some space below the last input field
            // when screen height is smaller than the content height
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 20
            }
        }
    }

    ButtonShelf {
        id: buttonShelf
        firstButtonText: qsTr("Apply")
        secondButtonText: qsTr("Cancel")
        onFirstButtonPressed: {
            updateCheck()
        }
        onSecondButtonPressed: {
            activestack.pop()
            console.log("You have canceled the changes")
        }
    }
}
