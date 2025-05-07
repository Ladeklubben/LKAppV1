import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import QtQuick 2.12

/* This is the listview and the footer with the create button */
ListView{
    clip: true;
    property color but_plus_color;
    property color but_minus_color;
    signal createNewEvent();
    spacing: 5;
    footerPositioning: ListView.OverlayFooter;
    ScrollBar.vertical: LKScrollBar{
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    footer:
        Rectangle {
        color: lkpalette.g_page_bg;
        z: 10;
        height: 100;
        width: parent.width;

        Rectangle{
            width: parent.width;
            height: 1;
            color: lkpalette.seperator
        }

        Row{
            anchors.fill: parent;
            Item{
                height: parent.height;
                width: 100;
                Rectangle{
                    width: 70;
                    height: width
                    radius: width/2;
                    color: but_plus_color;
                    anchors.centerIn: parent;
                    Label{
                        anchors.centerIn: parent
                        text: "+"
                        font.pointSize: 36;
                        color: "white";
                    }
                }
                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        createNewEvent();
                    }
                }
            }
            Item{
                height: parent.height;
                width: parent.width - 100;
                Label{
                    text: qsTr("Create group");
                    color: lkpalette.base;
                    font.pointSize: 12;
                    font.bold: true;
                    anchors.verticalCenter: parent.verticalCenter;
                }
            }
        }
    }
}
