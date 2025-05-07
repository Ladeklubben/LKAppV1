import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtQuick 2.12

Item{
    function get_paymentcards_list(){
        http.request('/paymentcards', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    var cl = JSON.parse(o.responseText);
                    cardslist.clear();
                    if(cl.length === 0){
                        cards_listview.delegate = no_cards_item;
                        cardslist.append({"NA": "Nothing"});
                        return;
                    }
                    cards_listview.delegate = card_item;
                    cl.forEach(function(l){
                        cardslist.append({
                                             "brand":l.brand,"last4":l.last4,"exp":l.exp,
                                             "created":l.created,"authorized":l.authorized,
                                             "verified":l.verified,"defaultcard":l['default'],
                                             "cardid": l.id
                                         })
                    });


                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });
    }

    function change_default_paymentcard(cardid){
        var body = {
            'cardid': cardid
        }

        http.put('/paymentcard/make_active', JSON.stringify(body), function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    //Refresh the list
                    get_paymentcards_list();
                }
                else if(o.status === 402){
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("The card is not known to the system, nothing changed")});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });

    }

    ListModel{
        id: cardslist;
    }

    function card_id_from(brand, last4){
        if(brand === "visadankort" )
            return "4571 XXXX XXXX " + last4;
        else if(brand === "mastercard"){
            return "5209 XXXX XXXX " + last4;
        }
        else if(brand === "dankort"){
            return "5019 XXXX XXXX " + last4;
        }
        else{
            return "XXXX XXXX XXXX " + last4;
        }
    }

    Component{
        id: no_cards_item
        Text{
            text: qsTr("No paymentcards tied to account")
            font.pointSize: 16;
            font.bold: true;
            font.italic: true
            color: lkpalette.base_white;
            height: 100;
            width: cards_listview.width;
            wrapMode: Text.Wrap;
        }
    }

    Component{
        id: card_item;
        Rectangle{
            color: "transparent"
            border.color: defaultcard ? lkpalette.signalgreen : "transparent";
            border.width: 5;
            radius: 5;
            height: 100;
            width: cards_listview.width;
            Label{
                id: cardicon;
                anchors.left: parent.left;
                anchors.leftMargin: 10;
                width: 75;
                height: parent.height;
                text: brand === "visadankort" ? "\uF1F0" : brand === "mastercard" ? "\uF1F1" : "\uE80D";
                fontSizeMode: Text.Fit;
                minimumPixelSize: 10; font.pixelSize: 60
                font.family: lkfonts.name;
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter;
                color: lkpalette.base_white;
            }
            Label{
                anchors.left: cardicon.right;
                anchors.leftMargin: 10;
                height: parent.height;
                text: card_id_from(brand, last4);
                color: lkpalette.base_light
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter;
                font.pointSize: 16;
                font.bold: true;
            }

            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    change_default_paymentcard(cardid);
                }
            }
        }
    }

    ListView{
        id: cards_listview;
        anchors.margins: 5;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: parent.top;
        anchors.bottom: add_new_button.top;
        model: cardslist;
        delegate: card_item
    }
    LKButtonV2{
        id: add_new_button;
        text: qsTr("Add payment card");
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.margins: 5;
        height: 60;
        onClicked: {
            activestack.push(add_card);
        }
    }

    Component{
        id: add_card;
        CardRenew{
            property string headertext: qsTr("ADD CARD")

            onDone: function(){
                activestack.pop();
                get_paymentcards_list();
            }

            onCancel: function(){
                //The user hit the back button - the same as a cancel - go all the way back
                activestack.pop();
            }
        }
    }

    Component.onCompleted: {
        get_paymentcards_list();
        header.headText = qsTr("PAYMENT CARDS")
    }
}
