import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtQuick 2.12
Item{
    id: lklw;
    property Component delegate;
    //property Component header;
    property alias header: lw.header;
    property alias headerPositioning: lw.headerPositioning;
    property alias highlight: lw.highlight;
    property alias currentIndex: lw.currentIndex;
    property alias spacing: lw.spacing;
    property alias model: lw.model;

    property bool remove_enabled: true;

    signal remove(var index);
    signal item_clicked(var index);

    Component{
        id: im;
        Item{
            id: di;
            height: delegateloader.height; //150;
            width: lw.width;

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
                id: flicker;
                property real update_rdy: 0;
                interactive: remove_enabled;
                flickableDirection: Flickable.HorizontalFlick;
                width: parent.width;
                height: parent.height;

                onMovementEnded: {
                    update_rdy = 0;
                    lw.interactive = true;
                }
                onMovementStarted: lw.interactive = false;

                onContentXChanged: {
                    if(contentX < -width/3 && !update_rdy){
                        update_rdy = 1;
                        remove(index);
                    }
                }

                Rectangle{  //This rect is used to hide the remove label when flickering
                    anchors.fill: parent;
                    color: lkpalette.base;
                    Loader{
                        id: delegateloader;
                        sourceComponent: model.index >= 0 ? delegate : undefined;

                        property int index: model.index;
                        property var propData: lw.model.get(index);

                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                item_clicked(index);
                            }
                        }
                    }
                }
            }
        }
    }

    ListView{
        id: lw;
        anchors.fill: parent;
        //spacing: 5;
        delegate: im;
        clip: true;
        highlightMoveDuration: 0
        ScrollBar.vertical: LKScrollBar{
            anchors.top: lw.top
            anchors.right: lw.right
            anchors.bottom: lw.bottom
        }
    }
}
