import QtQuick 2.12

Item {
    Column{
        anchors.fill: parent;
        anchors.margins: 20;
        spacing: 20;

        LKMenuItem{

            function cb(ok, retval){

            }

            height: menuItemHeight;
            width: parent.width;
            anchors.left: parent.left;
            icon: "\uE801";
            text: qsTr("Reboot charger");
            description: qsTr("The charger will reboot");
            onClicked: activestack.push(charger_ctrl);
            icon_color: lkpalette.menuItemIcon1
            icon_bk_color: lkpalette.menuItemBackground1
        }
    }

    Component.onCompleted: {
        header.headText = qsTr("COMMANDS")
    }
}
