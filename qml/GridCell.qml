import QtQuick
import QtQuick.Layouts

Column {
    property string title: title
    property string value: value


    spacing: 2
    width: parent.width / parent.columns
    Text { 
        text: title
        font.pointSize: 14

        color: lkpalette.base_white;
    }
    Text { 
        text: value
        color: lkpalette.base_white;
        font.bold: true 
        font.pointSize: 24
    }
}