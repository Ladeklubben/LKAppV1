import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item{
    property alias text: settingstext.text;
    property alias helper: help.helpertext;
    property bool enabled: true;
    height: 50;
    width: parent.width;

    property int activated: 1;
    property bool changed: false;
    onActivatedChanged: {
        changed = true;
    }

    Row{
        spacing: 10;
        width: parent.width/2;
        height: parent.height;
        Label{
            id: settingstext;
            font.pointSize: lkfont.sizeNormal;
            color: "white";
            anchors.verticalCenter: parent.verticalCenter;
        }
        LKHelp{
            id: help;
            width: 30;
            height: parent.height;
            visible: helpertext !== "";
            pointsize: lkfont.sizeNormal;
        }
    }

    LKButton{
        id: button_picker;
        button_radius: 5;
        width: parent.height;
        height: parent.height;
        color: activated &&  enabled ? lkpalette.signalgreen : lkpalette.buttonDisabled;
        anchors.right: parent.right;
        enabled: parent.enabled;

        onClicked: {
            activated = !activated;
        }
    }

    Component.onCompleted: {
        changed = false;
    }
}
