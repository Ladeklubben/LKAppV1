import QtQuick 2.13

LKIconButton{
    property string helpertext: "";
    text: "\uF29C";

    onClicked: {
        alertbox.setSource("LKAlertBox.qml", {"message": helpertext});
    }
}
