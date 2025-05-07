import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Column{
    id: list_of_items;
    spacing: 15;

    //The items shall have a name and a selected property. If its selected, it will be marked
    //If multiselect is true, all items can be marked at once, else its only the last one
    property ListModel items;
    property bool multiselect: true;
    property int selected_count: 0;

    function deselect_all_but(idx){
        if(multiselect) return;

        for(var i=0; i<items.count; i++){
            if(i === idx) continue;
            if(items.get(i).selected === true)
            {
                items.setProperty(i, "selected", false);
                selected_count--;
            }
        }
    }

    Repeater{
        delegate: list_item;
        model: items;
    }

    Component{
        id: list_item;
        Rectangle{
            color: selected ? lkpalette.base_grey : "transparent";
            width: list_of_items.width;
            height: 50;
            LKLabel{
                text: name;
                anchors.verticalCenter: parent.verticalCenter;
            }
            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    deselect_all_but(index);
                    selected = !selected;
                    if(selected) selected_count++;
                    else selected_count--;
                }
            }
            Component.onCompleted: {
                if(selected) selected_count++;
            }
        }
    }

    Component.onCompleted: {

    }
}
