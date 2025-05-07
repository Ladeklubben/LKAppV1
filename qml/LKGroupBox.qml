import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12


Rectangle{
    color: "transparent"
    border.width: 2;
    border.color: "white";
    radius: 3;

    width: parent.width;
    height: lw.contentHeight + 25;

    property string headline;

    function clearView(){
        groupboxitems.clear();
    }

    function add(obj){
        groupboxitems.append({"key":obj.key, "value": obj.value});
    }

    ListView{
        id: lw;
        anchors.margins: 5
        anchors.fill: parent;
        spacing: 5;
        header: Label{
            id: headlinefield;
            width: lw.width
            height:contentHeight;
            text: headline;
            color: "white";
            font.pointSize: 18;
            font.bold: true;
        }
        clip: true;
        interactive: false;
        model: groupboxitems
        delegate: LKTextField{
            name: key;
            text: value;
        }

        ListModel{
            id: groupboxitems

//            ListElement{
//                key: "Data:"
//                value: "Pending..."
//            }

        }
    }
}


