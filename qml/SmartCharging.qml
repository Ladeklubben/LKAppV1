import QtQuick
import QtQuick.Layouts
 import QtQuick.Controls

Item {
    id: outFocuser;
    property bool haschanged: true;
    property bool smartenabled;
    property string startcharge_at;
    property string stopcharge_at;
    property int preheattime;
    property int needed_energy;
    property bool can_submit: preheat.valid && startcharge_setup.valid && stopcharge_setup.valid && energysetup.valid;

    ScrollView{
        id: sw;
        anchors{
            left: parent.left;
            right: parent.right;
            top: parent.top;
            bottom: donewidget.top;
            margins: 5;
        }

        TapHandler { onTapped: outFocuser.forceActiveFocus();}


    ColumnLayout{
        spacing: 30;
        width: parent.width;

        LKLineElementWHelp{
            text: qsTr("Enable smart charging") + ":";
            helpertext: qsTr("If smart charging is enabled, automatic-on and manual-on charging sessions will charge when energyprices are the lowest")
            element: Row{
                height: parent.height;
                LKButton{
                    button_radius: 5;
                    height: parent.height;
                    width: parent.height;

                    color: smartenabled ? lkpalette.signalgreen : lkpalette.buttonDisabled;
                    onClicked: {
                        smartenabled = !smartenabled;
                        haschanged = true;
                    }
                }
            }
        }


        LKLineElementWHelp{
            id: startcharge_setup
            property bool valid: false;
            property string hour;
            property string minute;

            text: qsTr("Charging start") + ":";
            helpertext: qsTr("This is the earliest a charging session will begin")

            element:LKTimeEntry{
                hour: startcharge_setup.hour;
                minute: startcharge_setup.minute

                onValidChanged: {
                    startcharge_setup.valid = valid;
                }
                callback: function(hour, minute){
                    startcharge_at = hour + ":" + minute;
                    haschanged = true;
                }
            }
        }

        LKLineElementWHelp{
            id: stopcharge_setup;
            property bool valid: false;
            property string hour;
            property string minute;

            text: qsTr("Charging stop") + ":";
            helpertext: qsTr("This is the latest a charging session will end. Typically the time where you need to use your car")
            element:LKTimeEntry{
                hour: stopcharge_setup.hour;
                minute: stopcharge_setup.minute
                onValidChanged: {
                    stopcharge_setup.valid = valid;
                }
                callback: function(hour, minute){
                    stopcharge_at = hour + ":" + minute;
                    haschanged = true;
                }
            }
        }

        LKLineElementWHelp{
            id: energysetup;
            property bool valid: false;
            property int amount;

            text: qsTr("Needed amount of energy") + ":";
            helpertext: qsTr("E.g. if you have used 50% of a 80kWh battery, you will need 40kWh")

            element:Row{
                spacing: 5;
                height: parent.height;
                LKTextEdit{
                    width: 75;
                    height: parent.height;
                    verticalAlignment: TextEdit.AlignBottom;
                    horizontalAlignment: TextEdit.AlignHCenter;
                    validator: IntValidator{bottom: 1; top: 150;}
                    indicate_error: !acceptableInput;
                    text: energysetup.amount;
                    onTextChanged: {
                        energysetup.valid = acceptableInput;
                        if(acceptableInput){
                            needed_energy = parseInt(text);
                            haschanged = true;
                        }
                    }
                }
                LKLabel{
                    text: "kWh";
                    color: lkpalette.text_dimmed;
                    height: parent.height;
                    verticalAlignment: TextEdit.AlignBottom;
                }
            }
        }

        LKLineElementWHelp{
            id: preheat;
            property bool valid;

            property string hour;
            property string minute;

            text: qsTr("Preheat time") + ":";
            helpertext: qsTr("Set the amount of minutes that your car will need power to heat the cabin. Power will be enabled at the end of the charging session")
            element:LKTimeEntry{
                id: preheat_time_setup;
                hour: preheat.hour;
                minute: preheat.minute;

                onValidChanged: {
                    preheat.valid = valid;
                }
                callback: function(hour, minute){
                    preheattime = parseInt(hour) * 60 + parseInt(minute);
                    haschanged = true;
                }
            }
        }
    }
    }

    LKButtonRowSubmitHelp{
        id: donewidget;
        help: qsTr("You can setup how a smart charging session shall behave. When it should start, when it should be finished, and how much power you will need.") + " " +
              qsTr("Changes will have effect on your next charging session.");
        property bool busy: false;
        enable_submit: preheat.valid && startcharge_setup.valid && stopcharge_setup.valid && energysetup.valid && !busy && haschanged;
        anchors{
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        function sending_done(status, retval){
            busy = false;
            if(status) haschanged = false;
        }

        submit: function(){
            var setup = {
                "charging_begin_earliest": startcharge_at,
                "charging_end_latest": stopcharge_at,
                "needed_energy": needed_energy,
                "preheat": preheattime
            }
            busy = true;
            lkinterface.charger.set_smart_charge(activeCharger.id, smartenabled, setup, sending_done);
        }
    }

    function setup_received(status, retval){
        if(!status){
            return;
        }
        if(retval === null){
            return;
        }
        let s = retval['charging_begin_earliest'].split(":");
        startcharge_setup.hour = s[0];
        startcharge_setup.minute = s[1];

        s = retval['charging_end_latest'].split(":");
        stopcharge_setup.hour = s[0];
        stopcharge_setup.minute = s[1];

        energysetup.amount = retval['needed_energy'];

        let ph = retval['preheat'];
        preheat.hour = parseInt(ph/60);
        preheat.minute = ph - preheat.hour * 60;

        if('enabled' in retval){
            smartenabled = true;
        }

        haschanged = false;
    }

    Component.onCompleted: {
        lkinterface.charger.get_smart_charge_setup(activeCharger.id, setup_received);
        header.headText = qsTr("SMART CHARGING")
    }
}
