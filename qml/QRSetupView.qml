import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtQuick

Item {
    property string scanned_qr_code;

    function get_qr_code(){
        http.request("/cp/" + activeCharger.id + "/qrtag", '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    var qr = JSON.parse(o.responseText);
                    qrcodemodel.clear();
                    if(qr != null){
                        qrcodemodel.append({"QRTAG": qr});
                    }
                }
                else if(o.status === 403) {
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("This chargepoint is not a smart charger and thus can not have a QR-code")});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });
    }

    function update_qr_code(qr){
        http.put("/cp/" + activeCharger.id + "/qrtag?qrcode=" + qr, '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    get_qr_code();
                }
                else if(o.status === 403) {
                    alertbox.setSource("LKAlertBox.qml", {"message": qsTr("QR code is already in use - unable to change it")});
                }
                else{
                    alertbox.setSource("LKAlertBox.qml", {"message": o.responseText});
                }
            }
        });
    }


    ListModel{
        id: qrcodemodel;
    }

    Component{
        id: qritem
        Label{
            height: 100;
            width: lw.width;
            text: qrcodemodel.get(index).QRTAG;
            color: "white";
            font.pointSize: lkfont.sizeLarge;
            horizontalAlignment: Text.AlignHCenter;
            verticalAlignment: Text.AlignVCenter;
        }
    }

    LKListview{
        id: lw;
        anchors.margins: 5;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: parent.top;
        anchors.bottom: update_qr_button.top;
        model: qrcodemodel;
        delegate: qritem;
        clip: true;
        remove_enabled: false;
    }

    LKIconButton{
        id: update_qr_button;
        anchors.bottom: parent.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        width:  200;
        height: 200;
        text: "\uE80C";
        onClicked: {
            activestack.push(qrscanner);
        }
    }

    Component{
        id: qrscanner;
        LKQRScanner{
            onQrcode_found: {
                var code = qrtools.parse(tag);
                if(code){
                    scanned_qr_code = code;
                }
                activestack.pop();
            }
        }
    }


    onScanned_qr_codeChanged: {
        if(scanned_qr_code === '') return;
        update_qr_code(scanned_qr_code);
        scanned_qr_code = '';
    }

    Component.onCompleted: {
        get_qr_code();
        header.headText = qsTr("QR-TAG SETUP")
    }
}
