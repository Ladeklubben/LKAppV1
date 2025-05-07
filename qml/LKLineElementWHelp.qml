import QtQuick
import QtQuick.Layouts

Item{
    property alias text: linetxt.text;
    property alias helpertext: helper.helpertext;
    property alias element: itemloader.sourceComponent; //content.children;

    Layout.fillWidth: true;
    Layout.preferredHeight: 75;
    ColumnLayout{
        anchors.margins: 5;
        anchors.fill: parent;
        RowLayout{
            Layout.fillWidth: true;
            Layout.fillHeight: true;
            spacing: 10;
            LKLabel{
                id: linetxt;
            }
            LKHelp{
                id: helper;
                Layout.fillHeight: true;
                Layout.preferredWidth: 30;

                onClicked: {
                    alertbox.setSource("LKAlertBox.qml", {"message": helpertext});
                }
            }
            Item{
                //Fill item, to make the rest align to the right
                Layout.fillHeight: true;
                Layout.fillWidth: true;
            }
            Loader{
                id: itemloader;
                Layout.fillHeight: true;
                Layout.fillWidth: false;
            }
        }
    }
    LKSeperator{

    }
}
