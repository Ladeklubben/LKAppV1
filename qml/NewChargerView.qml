import QtQuick
import QtQuick.Layouts

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        // Spacer item to push content down from top
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredHeight: 1
        }

        LKText {
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            wrapMode: Text.WordWrap
            text: qsTr("After you add a new charger, you will receive an email with the necessary parameters for configuring the backend connection.\n
                        The setup process varies depending on your charger brand. Please refer to your charger's manual if you need guidance.\n\n
                        The charger will be deleted if no data has been received by the backend for 14 days.
                        ")
        }

        // Spacer item to push button to bottom
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredHeight: 1
        }

        LKButtonV3 {
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.preferredHeight: 75;
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            text: qsTr("Add charger")

            function callback(ok, stationobj){
                if(ok){
                    root.stations.push(stationobj)
                    root.stationsCount = root.stations.length;
                    activestack.pop();
                }
            }

            onClicked:{
                lkinterface.user.add_new_charger(callback);
            }
        }
    }
}
