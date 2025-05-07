import QtQuick 2.1
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
Rectangle {
    height: 65;
    property string subtext: ""
    property string headText: ""
    property int rightmargin: 0
    property int leftmargin: 0
    property bool headerVisible: backArrow.visible
    signal itemClicked(var item);
    function showPage(page){
        itemClicked(page);
        activestack.push(page);
    }

    color: lkpalette.base_extra_dark;
    width: parent.width;
    Rectangle{

        id: header;
        color: lkpalette.base_extra_dark;
        width: parent.width;
        height: parent.height - 3

        RowLayout{
            anchors.fill: parent;
            anchors.margins: 20;

            LKIconButton{
                id: backArrow
                text: "\uE822";
                pointsize: 30;
                width: 30;
                height: 30;
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                visible: true;
                onVisibleChanged: !visible? leftmargin = 30 : leftmargin = 0
                onClicked:{
                    activestack.goBack();
                }
            }

            Label {
                id: headerlbl
                text: headText
                color: "white"
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
                Layout.leftMargin: leftmargin
                Layout.rightMargin: rightmargin
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter | Qt.AlignVCenter
                font.pointSize: 18
                font.bold: true
                // This will center the label in its parent
                Layout.alignment: Qt.AlignCenter
            }
        }

        Label {
            id: headerSubtext
            text: subtext
            color: "white"
            elide: Label.ElideRight
            font.pointSize: 11
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
