import QtQuick.Controls 2.12
import QtQuick 2.0

Item {
    /* Poll the server untill the card revision has changed. */
    function poll_for_card_validation() {
        http.request('/verify_card', '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    activestack.pop();
                }
            }
        });
    }

    Label{
        id: busytxt
        anchors.centerIn: parent;
        text: qsTr("Waiting for card approval...")
        color: "white"
    }

    LKBusyIndicator{
        anchors.bottom: busytxt.top;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.bottomMargin: 30;
    }

    Timer{
        id: polltimer;
        interval: 1000;
        onTriggered: {
            poll_for_card_validation();
        }
    }

    Component.onCompleted: {
        polltimer.start();
    }
}
