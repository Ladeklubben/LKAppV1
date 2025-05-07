import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

ColumnLayout{

    property string weekday: "";
    spacing: 5;

    property alias starthour : fromhour.text;
    property alias startminute: fromminute.text
    property alias interval_hour: intervalhour.text;
    property alias interval_minute: intervalminute.text;

    signal timeChanged();
    signal intervalChanged();

    Label{
        text: weekday;
        color: "white";
        font.pointSize: 18;
    }
    RowLayout{
        Layout.fillWidth: true;
        GroupBox{
            Layout.fillWidth: true;
            label: Label{
                text: qsTr("Start:");
                color: "white";
            }

            RowLayout{
                Layout.fillWidth: true;
                anchors.left: parent.left;
                anchors.right: parent.right;
                LKTextEdit{
                    id: fromhour;
                    headline: qsTr("Hour")
                    Layout.fillWidth: true;
                    inputMethodHints: Qt.ImhTime | Qt.ImhDigitsOnly;
                    validator: IntValidator{bottom: 0; top: 23;}
                    indicate_error: !acceptableInput;
                    horizontalAlignment: TextEdit.AlignHCenter;
                    text: starthour;
//                    onValueChanged: {
//                        timeChanged();
//                    }
//                    onTextChanged: {
//                        console.log("bvujvfd");
//                    }
                    onFocusChanged: {
                        if(!focus && acceptableInput){
                            timeChanged();
                        }
                    }
                }
                Label{
                    font.pointSize: lkfont.sizeLarge;
                    text: ":";
                    color: "white";
                    Layout.fillHeight: true;
                    verticalAlignment: TextEdit.AlignVCenter;
                }
                LKTextEdit{
                    id: fromminute
                    headline: qsTr("Minute")
                    Layout.fillWidth: true;
                    inputMethodHints: Qt.ImhTime | Qt.ImhDigitsOnly;
                    validator: IntValidator{bottom: 0; top: 59;}
                    indicate_error: !acceptableInput;
                    horizontalAlignment: TextEdit.AlignHCenter;
                    text: startminute;
//                    onValueChanged: {
//                        timeChanged();
//                    }
                    onFocusChanged: {
                        if(!focus && acceptableInput){
                            timeChanged();
                        }
                    }
                }
            }

        }

        GroupBox{ //116
            Layout.fillWidth: true;
            label: Label{
                text: qsTr("Stop after:");
                color: "white";
            }
            RowLayout{ //12
                Layout.fillWidth: true;
                anchors.left: parent.left;
                anchors.right: parent.right;

                LKTextEdit{
                    id: intervalhour
                    headline: qsTr("Hour(s)")
                    Layout.fillWidth: true;
                    validator: IntValidator{bottom: 0; top: 72;}
                    indicate_error: !acceptableInput;
                    horizontalAlignment: TextEdit.AlignHCenter;
                    text: interval_hour;
//                    onValueAccepted: {
//                        console.log("intervalhour Accepted", text)
//                    }

//                    onValueChanged: {
//                        intervalChanged();
//                    }
                    onFocusChanged: {
                        if(!focus && acceptableInput){
                            intervalChanged();
                        }
                    }

                }
                Label{
                    font.pointSize: lkfont.sizeLarge;
                    text: ":";
                    color: "white";
                    Layout.fillHeight: true;
                    verticalAlignment: TextEdit.AlignVCenter;
                }
                LKTextEdit{
                    id: intervalminute
                    headline: qsTr("Minute(s)")
                    Layout.fillWidth: true;
                    validator: IntValidator{bottom: 0; top: 59;}
                    indicate_error: !acceptableInput;
                    horizontalAlignment: TextEdit.AlignHCenter;
                    text: interval_minute;
//                    onValueAccepted: {
//                        console.log("intervalminute Accepted", text)
//                    }

//                    onValueChanged: {
//                        intervalChanged();
//                    }
                    onFocusChanged: {
                        if(!focus && acceptableInput){
                            intervalChanged();
                        }
                    }
                }
            }
        }
    }
}
