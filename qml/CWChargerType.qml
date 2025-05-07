import QtQuick 2.0
import QtQuick.Window 2.13
import QtQuick.Controls 2.14
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtLocation 5.14
import QtPositioning 5.14


ColumnLayout{
    spacing: 25;

    Label{
        text: qsTr("Specify Charger") + ":";
        color: "White";
        font.bold: true;
        font.pointSize: lkfont.sizeNormal;
    }

    GridLayout{
        columns: 2;
        rowSpacing: 30;
        columnSpacing: 20;

        Label{
            text: qsTr("Brand") + ":";
            color: "White";
            font.bold: true;
            font.pointSize: lkfont.sizeNormal;
        }
        TextField {
            id: brandfield;
            Layout.fillWidth: true;
            verticalAlignment : TextInput.AlignVCenter;
            horizontalAlignment: TextInput.AlignLeft;
            font.pointSize: lkfont.sizeNormal;
            color: "white";
            placeholderText: qsTr("eg. Heidelberg");
            placeholderTextColor: lkpalette.buttonDown;
            background:Rectangle{
                radius: 3;
                color: lkpalette.button;
                border.color: "white";
                border.width: 2;
            }
            text: brand;
            onTextEdited: {
                brand = text;
            }
        }

        Label{
            text: qsTr("Model") + ":";
            color: "White";
            font.bold: true;
            font.pointSize: lkfont.sizeNormal;
        }
        TextField {
            id: modelfield;
            Layout.fillWidth: true;
            verticalAlignment : TextInput.AlignVCenter;
            horizontalAlignment: TextInput.AlignLeft;
            font.pointSize: lkfont.sizeNormal;
            color: "white";
            placeholderText: qsTr("eg. Wallbox 11kw");
            placeholderTextColor: lkpalette.buttonDown;
            background:Rectangle{
                radius: 3;
                color: lkpalette.button;
                border.color: "white";
                border.width: 2;
            }
            text: model;
            onTextEdited: {
                model = text;
            }
        }

        Label{
            text: qsTr("Power") + ":";
            color: "White";
            font.bold: true;
            font.pointSize: lkfont.sizeNormal;
        }
        RowLayout{
            TextField {
                id: powersizefield;
                Layout.fillWidth: false;
                Layout.preferredWidth: 75;
                verticalAlignment : TextInput.AlignVCenter;
                horizontalAlignment: TextInput.AlignHCenter;
                font.pointSize: lkfont.sizeNormal;
                color: "white";
                background:Rectangle{
                    radius: 3;
                    color: lkpalette.button;
                    border.color: "white";
                    border.width: 2;
                }
                text: psize;
                onTextEdited: {
                    psize = text;
                }
            }
            Label{
                text: "kW";
                color: "White";
                font.bold: true;
                font.pointSize: lkfont.sizeNormal;
                Layout.fillWidth: true;
            }
        }
    }

    SwipeView{
        id: typepicker

        width: parent.width;
        height: 300;
        currentIndex: 1;
        property string chargetype: "";
        Item{
            property string type: "TYPE 1"
            Image {
                anchors.centerIn: parent;
                source: "icons/ev_type1.png"
            }
        }
        Item{
            property string type: "TYPE 2"
            Image {
                anchors.centerIn: parent;
                source: "icons/ev_type2.png"
            }
        }
        Item{
            property string type: "TYPE 2 + CCS"
            Image {
                anchors.centerIn: parent;
                source: "icons/ev_type2comboCCS.png"
            }
        }
        Item{
            property string type: "CHADEMO"
            Image {
                anchors.centerIn: parent;
                source: "icons/ev_typechademo.png"
            }
        }

        onCurrentItemChanged: {
            conntype = currentItem.type;
        }
        Component.onCompleted: {
            var items = contentChildren;
            for( var i = 0; i < items.length; i++){
                if(items[i].type === conntype){
                    setCurrentIndex(i);
                    break;
                }
            }
        }
    }

    Label{
        id: typetext;
        color: "White";
        font.bold: true;
        font.pointSize: lkfont.sizeNormal;
        text: conntype;
    }
}
