import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

LKStackView {
    id: stack

    initialItem: map;
    property string headertext: qsTr("LADEKLUBBEN")
    property string activeqr;
    property string active_charging_session: '';

    Component{
        id: map;
        ChargerMap{
            property string headertext: qsTr("LADEKLUBBEN")

            onClaim:function(id){
                stack.push(guestcharge, {stationid: id});
            }

            MapData{
                id:mdata;
            }

            ListModel{
                id: list_of_markers;
            }

            Component.onCompleted: {
                header.subtext = "";
            }          
        }
    }

    Component{
        id: guestcharge;
        GuestCharge{
            property string headertext: qsTr("GUEST CHARGE")
        }
    }

    Component{
        id: qrscanner;
        LKQRScanner{
            property string headertext: qsTr("Scan QR Code")

            onQrcode_found: function(tag){
                var code = qrtools.parse(tag);
                if(code){
                    activeqr = code;
                }
                activestack.pop();
            }
        }
    }

    function check_user_charging_state(ok, charging_at){
        if(!ok) return;
        try{
            let s = charging_at['active_charging_session'];
            active_charging_session = s;
        }
        catch(error){

        }
    }

    Component.onCompleted: {
        lkinterface.user.is_user_guest_charging(check_user_charging_state);
    }
}


