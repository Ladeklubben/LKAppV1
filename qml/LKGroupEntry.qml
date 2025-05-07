import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import QtQuick.Layouts 1.12
import QtQuick 2.12

Item{
    id: ge;
    Layout.fillWidth: true;
    Layout.fillHeight: false;
    height: 120;

    signal remove();
    signal clicked();
    signal movementEnded();
    signal movementStarted();
    signal settings_clicked();

    property Component tarif;
    property var groupobj;
    property var groupcolor;
    property int memberscount;

    Label{
        visible: flicker.contentX < 0;
        anchors.left: parent.left;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.leftMargin: 30;
        color: "red";
        text: qsTr("REMOVE");
        font.bold: true;
        font.pointSize: 16;
    }

    Flickable{
        id: flicker
        property real update_rdy: 0;
        flickableDirection: Flickable.HorizontalFlick;
        interactive: true;

        height: parent.height;
        width: parent.width;

        onMovementEnded: ge.movementEnded();
        onMovementStarted: ge.movementStarted();

        onContentXChanged: {
            if(contentX < -width/3 && !update_rdy){
                update_rdy = 1;
                ge.remove();
            }
        }

        Rectangle{
            radius: 10;

            height: parent.height;
            width: parent.width;


            Item{
                height: parent.height;
                width: parent.width;


                ColumnLayout{
                    id: ginfobox;
                    anchors.fill: parent;
                    anchors.leftMargin: 25
                    anchors.topMargin: 5;
                    anchors.rightMargin: 20;
                    anchors.bottomMargin: 5;

                    Label{
                        id: gentry;
                        text: groupobj.info.title;
                        font.bold: true;
                        font.pointSize: 16;
                        color: lkpalette.base;
                    }
                    Label{
                        text: groupobj.info.brief;
                        color: "grey";
                        font.pointSize: 12;
                    }

                    Loader{
                        id: tarifcomploader
                        sourceComponent: tarif;
                    }

                    RowLayout{
                        Label{
                            text: qsTr("Members") + ":"
                            color: lkpalette.base;
                            font.italic: true;
                        }
                        Label{
                            text: memberscount; //groupobj.memberscount === undefined ? '0' : groupobj.memberscount;
                            color: lkpalette.base;
                            font.italic: true;
                            font.pointSize: 8;
                        }
                    }
                }
                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        ge.clicked();
                    }
                }
            }

            Label{
                anchors.margins: 10;
                anchors.right: parent.right;
                anchors.bottom: parent.bottom;
                font.family: lkfonts.name;
                text: "\uE800"  //SETTINGS GEAR
                font.pointSize: 32;
                color: groupcolor

                MouseArea{
                    id: settingsbutton;
                    anchors.fill: parent;
                    onClicked: settings_clicked();
                }
            }

            Rectangle{
                anchors.top: parent.top;
                anchors.left: parent.left;
                anchors.bottom: parent.bottom;
                anchors.margins: 5;
                anchors.rightMargin: 10;
                radius: 10;
                color: groupcolor;
                width: 5;
            }
        }
    }
}
