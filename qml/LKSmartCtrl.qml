import QtQuick
import QtQuick.Layouts

Rectangle {
    id: sc;
    property int active_state;
    property bool smart_operation_enabled: false;
    property double smart_charge_start_time;
    signal schedule_plot_clicked();

    function smart_setup_done(){
        pause.spin_running = false;
        play.spin_running = false;
        recalc.spin_running = false;
        ctrlbox.enabled = true;
    }

    onSmart_charge_start_timeChanged:{
        polltimer.stop();
        smart_setup_done();
    }

    onActive_stateChanged:{
        polltimer.stop();
        smart_setup_done();
    }

    function handle_smart_changed(ok, retval){
        if(ok){
            ctrlbox.enabled = false;
            polltimer.restart();
        }
        else{
            smart_setup_done();
        }
    }

    function play() { return lkinterface.charger.set_charger_smart_play(stationid, handle_smart_changed) }
    function pause(){
        if(active_state != 1){
            return lkinterface.charger.set_charger_smart_pause(stationid, handle_smart_changed)
        }
        smart_setup_done();
    }
    function recalc(){ return lkinterface.charger.set_charger_smart_recalc(stationid, handle_smart_changed)}

    radius: 20;
    color: lkpalette.base_extra_dark;

    ColumnLayout{
        id: ctrlbox;
        spacing: 10;
        anchors.fill: parent;
        anchors.margins: 20;
        RowLayout{
            id: content;
            spacing: 10;
            Item{
                Layout.fillWidth: true;
                Layout.fillHeight: false;
                Layout.preferredHeight: 30;

                LKIconButton{
                    id: pause;//Pause
                    text: "\uE826";
                    anchors.fill: parent;
                    anchors.margins: 5;
                    onClicked: sc.pause();
                    spin_after_click: true;
                }

                LKSeperator{
                    color: active_state == 1 ? lkpalette.signalgreen : "transparent";
                }
            }

            Item{
                Layout.fillWidth: true;
                Layout.fillHeight: false;
                Layout.preferredHeight: 30;

                LKIconButton{   //Play
                    id: play;
                    text: "\uE827";
                    anchors.fill: parent;
                    anchors.margins: 5;
                    onClicked: sc.play();
                    spin_after_click: true;
                }

                LKSeperator{
                    color: active_state == 2 ? lkpalette.signalgreen : "transparent";
                }
            }

            Item{
                Layout.fillWidth: true;
                Layout.fillHeight: false;
                Layout.preferredHeight: 30;

                LKIconButton{   //Recalc
                    id: recalc
                    text: "\uE828";
                    enabled: smart_operation_enabled;
                    color: enabled ? lkpalette.base_white : "grey";
                    anchors.fill: parent;
                    anchors.margins: 5;
                    onClicked: sc.recalc();
                    spin_after_click: true;
                }

                LKSeperator{
                    color: active_state == 0 ? lkpalette.signalgreen : "transparent";
                }
            }
        }
        LKLabel{
            text: smart_charge_start_time > 0 ? qsTr("Charge start") + ": "+ datetime.format_time(smart_charge_start_time)  : qsTr("No charging scheduled");
        }
        LKMenuItem{
            Layout.fillHeight: false;
            Layout.fillWidth: true;
            Layout.preferredHeight: 100;
            icon: "\uE81F";
            text: qsTr("Smart charging schedule");
            description: qsTr("Check when charging is scheduled");
            onClicked: schedule_plot_clicked();
            icon_color: lkpalette.menuItemIcon5
            icon_bk_color: lkpalette.menuItemBackground5
        }
    }
    Timer{
        id: polltimer;
        property int pollcount: 0;
        running: false;
        interval: 2000;
        repeat: true;
        triggeredOnStart: false;
        onRunningChanged:{
            pollcount = 0;
        }
        onTriggered:{
            readings.force_update_states();
            pollcount += 1;
            if(++pollcount > 5){
                stop();
                smart_setup_done();
            }
        }

    }
}
