import QtQuick.Layouts 1.12
import QtQuick 2.15
import QtQuick.Controls 2.12

TextInput{
    id: te

    property int headline_font_pointSize_large: lkfont.sizeLarge;
    property int headline_font_pointSize_small: lkfont.sizeSmall;

    //Layout.preferredHeight: headline.text !== "" ? 60 : undefined;
    Layout.minimumHeight: 40;
    //Layout.preferredWidth: 100;
    verticalAlignment: TextEdit.AlignBottom;

    property alias headline: headlbl.text;
    property bool indicate_error: false;

    signal valueChanged();
    signal valueAccepted();
//    signal valueEdited();

    color: "white";
    font.pointSize: lkfont.sizeNormal;

    activeFocusOnPress: true;
    onActiveFocusChanged: {
        if(activeFocus) selectAll();
        else deselect();
    }

    Rectangle{
        height: 2;
        color: indicate_error ? "red" : lkpalette.seperator;
        width: parent.width;
        anchors.bottom: parent.bottom;
    }

    Label{
        id:headlbl
        color: lkpalette.text_dimmed;
        font.italic: true;
        states: [
            State {
                name: "hasfocus";
                when: te.activeFocus === true || te.text !== "";
                AnchorChanges {
                    target: headlbl;
                    anchors.top: te.top;
                    anchors.bottom: undefined;
                }
                PropertyChanges {
                    target: headlbl; font.pointSize: headline_font_pointSize_small;
                }
            },
            State{
                name: "nofocus";
                when: te.activeFocus === false;
                AnchorChanges {
                    target: headlbl;
                    anchors.bottom: te.bottom;
                    anchors.top: undefined;
                }
                PropertyChanges {
                    target: headlbl; font.pointSize: headline_font_pointSize_large;
                }
            }
        ]
        transitions: Transition {
            id: animation;
            enabled: false;
            AnchorAnimation {
                duration: 200
                easing.type: Easing.InCubic
            }
            PropertyAnimation{
                duration: 200
                easing.type: Easing.InCubic
                properties: "font.pointSize";
            }
        }
    }
    Component.onCompleted: {
        animation.enabled = true;
    }
}
