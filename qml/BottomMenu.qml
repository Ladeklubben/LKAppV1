import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: bottomMenu
    color: lkpalette.base_extra_dark

    states:[
        State {
            name: "hidden"; when: root.showMenuBar === false
            AnchorChanges{
                target: bottomMenu; anchors.top: parent.bottom; anchors.bottom: undefined
            }
        }
    ]

    transitions: Transition { AnchorAnimation { duration: 150 }}
    
    Rectangle {
        id: topBorder
        width: parent.width
        height: 2
        color: lkpalette.base_extra_dark
        anchors.top: parent.top
    }

    signal itemClicked(var item);
    function showPage(page){
        itemClicked(page);
        activestack.clear();
        activestack = rootstack;
        activestack.clear();
        activestack.push(page);
    }

    Row {
        id: menuRow
        anchors.centerIn: parent
        spacing: (parent.width - 200) / 5

        Item {
            width: 50
            height: 50
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    selectedPage = "map";
                    showPage(mapstack);
                }
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 5

                LKIcon {
                    text: "\uF279"
                    color: (selectedPage === "map") ? lkpalette.signalgreen : lkpalette.base_white
                    font.pointSize: 16
                    Layout.alignment: Qt.AlignCenter
                }

                Label {
                    text: qsTr("Map")
                    font.pointSize: 10
                    color: lkpalette.base_white
                    Layout.alignment: Qt.AlignCenter
                }
            }
        }

        Item {
            width: 50
            height: 50
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    selectedPage = "prices";
                    showPage(electricity_prices_page);
                }
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 5

                LKIcon {
                    text: "\uE818"
                    color: (selectedPage === "prices") ? lkpalette.signalgreen : lkpalette.base_white
                    font.pointSize: 16
                    Layout.alignment: Qt.AlignCenter
                }

                Label {
                    text: qsTr("Prices")
                    font.pointSize: 10
                    color: lkpalette.base_white
                    Layout.alignment: Qt.AlignCenter
                }
            }
        }

        Item {
            width: 50
            height: 50
            anchors.verticalCenter: parent.verticalCenter
            enabled: stationsCount > 0 ? true : false;
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    selectedPage = "charger";
                    showPage(station_swipeview);
                }
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 5

                LKIcon {
                    text: "\uF1E6"
                    color: enabled ? selectedPage === "charger" ? lkpalette.signalgreen : lkpalette.base_white : "grey"
                    font.pointSize: 16
                    Layout.alignment: Qt.AlignCenter
                }

                Label {
                    text: qsTr("Charger")
                    font.pointSize: 10
                    color: lkpalette.base_white
                    Layout.alignment: Qt.AlignCenter
                }
            }
        }

        Item {
            width: 50
            height: 50
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    selectedPage = "menu";
                    showPage(menuView);
                }
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 5

                LKIcon {
                    text: "\uF0C9"
                    color: (selectedPage === "menu") ? lkpalette.signalgreen : lkpalette.base_white
                    font.pointSize: 16
                    Layout.alignment: Qt.AlignCenter
                }

                Label {
                    text: qsTr("Menu")
                    font.pointSize: 10
                    color: lkpalette.base_white
                    Layout.alignment: Qt.AlignCenter
                }
            }
        }
    }
}
