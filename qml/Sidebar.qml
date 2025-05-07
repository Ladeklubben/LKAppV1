import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Drawer{

    width: 0.7 * root.width
    height: root.height

    signal itemClicked(var item);
    function showPage(page){
        itemClicked(page);
        activestack.push(page);
        close();
    }

    Rectangle {
        color: root.color;
        anchors.fill: parent;
        Rectangle{
            anchors.right: parent.right;
            color: lkpalette.border;

            width: border.width * 2;
            height: parent.height;
        }

        Flickable {
            interactive: true;
            boundsMovement: Flickable.StopAtBounds
            contentWidth: parent.width;
            contentHeight: content.implicitHeight + content.anchors.margins * 2;
            width: parent.width;
            height: parent.height - logo.height;
            clip: true;

            ColumnLayout{
                id: content;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.top: parent.top;
                anchors.margins: 15;
                spacing: 15;

                LKButton{
                    text: qsTr("Charger Map");
                    icon_txt: "\uF278"
                    icon_size: 30;
                    Layout.preferredHeight: 100;
                    Layout.fillWidth: true;
                    onClicked: {
                        activestack.clear();
                        activestack = rootstack;
                        rootstack.clear();
                        showPage(mapstack)
                    }
                }

                LKButton{
                    visible: loggedin && member_role !== 'Non-Member';
                    text: qsTr("Profile");
                    icon_txt: "\uF061"
                    icon_size: 30;
                    Layout.preferredHeight: 100;
                    Layout.fillWidth: true;
                    onClicked: {
                        showPage(menuView);
                    }
                }

                LKButton{
                    text: qsTr("StationView");
                    icon_txt: "\uE805"
                    icon_size: 30;
                    Layout.preferredHeight: 100;
                    Layout.fillWidth: true;
                    visible: loggedin && stations !== undefined && stations.length > 0;
                    enabled: stations !== undefined && stations.length > 0;
                    onClicked: {
                        activestack.clear();
                        activestack = rootstack;
                        rootstack.clear();
                        showPage(station_swipeview);
                    }
                }

                LKButton{
                    text: qsTr("Electricity prices");
                    icon_txt: "\uE802"
                    icon_size: 30;
                    Layout.preferredHeight: 100;
                    Layout.fillWidth: true;
                    onClicked: {
                        //activestack = rootstack;
                        showPage(electricity_prices_page);
                    }
                }

                LKButton{
                    text: qsTr("Admin");
                    icon_txt: "\uE844"
                    icon_size: 30;
                    Layout.preferredHeight: 100;
                    Layout.fillWidth: true;
                    enabled: member_role === "SuperAdmin"
                    visible: member_role === "SuperAdmin"
                    onClicked: {
                        showPage(adminpage);
                    }
                }

                LKButton{
                    text: loggedin ? qsTr("Log out") : qsTr("Log in");
                    icon_txt: "\uE804"
                    icon_size: 30;
                    Layout.preferredHeight: 100;
                    Layout.fillWidth: true;
                    onClicked: {
                        activestack.clear();
                        activestack = rootstack;
                        rootstack.clear();
                        credentials.password = "";
                        credentials.token = "";
                        showPage(loginstack);
                    }
                }
            }
        }
        Item{
            id: logo;
            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.bottomMargin: 10;
            height: 150;
            ColumnLayout{
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                anchors.centerIn: parent;
                Image {
                    source: "../icons/logo_invert.svg"
                    sourceSize.height: 100;
                    sourceSize.width: 100;
                }
                Label{
                    Layout.fillHeight: false;
                    Layout.fillWidth: false;
                    text: Qt.application.version;
                    color: lkpalette.buttonDown;
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                }
            }
        }
    }
}


