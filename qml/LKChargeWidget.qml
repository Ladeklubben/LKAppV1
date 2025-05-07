import QtQuick 2.14
import QtQuick.Shapes 1.14
import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12


Button {
    id: button
    property bool charging: true;
    property int barwidth: 20;

    function updateView(){
        baritems.append({"color": "#c6f200ff"});
    }

    background: Rectangle {
        color: "transparent";
        border.color: "white"
        border.width: 2;
        radius: 5;

        ListModel{
            id: baritems
        }

        ListView{
            spacing: 1;
            Layout.fillWidth: false;
            anchors.margins: 5;
            anchors.fill: parent;
            layoutDirection: Qt.LeftToRight
            clip: true;
            model: baritems
            orientation: ListView.Horizontal;
            interactive: false;
            delegate:   Rectangle{
                color: "#5cf628";
                width: barwidth;
                height: parent.height;
                Layout.fillHeight: true;
            }

            onContentWidthChanged: if(parent.width < contentWidth){
                                       baritems.clear();
                                   }
        }
    }

    Timer{
        id: shifttimer;
        running: true;
        interval: 800;
        repeat: true;
        triggeredOnStart: true;
        onTriggered: {
            updateView();
        }
    }

    Label{
        id: idlelabel;
        color: "white";
        visible: false;
        text: "Start charging"
        anchors.centerIn: parent;

    }

    onChargingChanged: {
        if(charging){
            shifttimer.interval = 500;
            shifttimer.running = true;
        }
        idlelabel.visible = !charging;
        shifttimer.running = charging;
        baritems.clear();

    }
}
