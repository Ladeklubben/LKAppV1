import QtQuick 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item{
    id: lkst

    property string starthour;
    property string startminute;

    property string tohour;
    property string tominute;

    signal startChanged();
    signal stopChanged();

    Column{
        width: parent.width;
        height: parent.height;
        Row{
            height: 50;
            spacing: 5;

            Label{
                font.pointSize: lkfont.sizeLarge;
                text: qsTr("Start:");
                color: "grey";
                horizontalAlignment: TextEdit.AlignHCenter;
            }

            LKTextEdit{
                id: fromhour;
                width: 100
                color: "grey";
                inputMethodHints: Qt.ImhTime | Qt.ImhDigitsOnly;
                //inputMask: "09";
                validator: IntValidator{bottom: 0; top: 23;}
                indicate_error: !acceptableInput;
                horizontalAlignment: TextEdit.AlignHCenter;
                text: starthour;
                onTextChanged: {
                    if(acceptableInput){
                        starthour = text;
                        startChanged();
                    }
                }
            }
            Label{
                width: 25
                font.pointSize: lkfont.sizeLarge;
                text: ":";
                color: "grey";
                verticalAlignment: TextEdit.AlignVCenter;
                horizontalAlignment: TextEdit.AlignHCenter;
            }
            LKTextEdit{
                id: fromminute
                width: 100
                color: "grey";
                inputMethodHints: Qt.ImhTime | Qt.ImhDigitsOnly;
                //inputMask: "99";
                validator: IntValidator{bottom: 0; top: 59;}
                indicate_error: !acceptableInput;
                horizontalAlignment: TextEdit.AlignHCenter;
                text: startminute;
                onTextChanged: {
                    if(acceptableInput){
                        startminute = text;
                        startChanged();
                    }
                }
            }
        }
        Row{
            height: 50;
            spacing: 5;

            Label{
                font.pointSize: lkfont.sizeLarge;
                text: qsTr("Stop:");
                color: "grey";
                horizontalAlignment: TextEdit.AlignHCenter;
            }

            LKTextEdit{
                id: endhour;
                width: 100
                color: "grey";
                inputMethodHints: Qt.ImhTime | Qt.ImhDigitsOnly;
                //inputMask: "09";
                validator: IntValidator{bottom: 0; top: 23;}
                indicate_error: !acceptableInput;
                horizontalAlignment: TextEdit.AlignHCenter;
                text: tohour;
                onTextChanged: {
                    if(acceptableInput){
                        tohour = text;
                        stopChanged();
                    }
                }
            }
            Label{
                width: 25
                font.pointSize: lkfont.sizeLarge;
                text: ":";
                color: "grey";
                verticalAlignment: TextEdit.AlignVCenter;
                horizontalAlignment: TextEdit.AlignHCenter;
            }
            LKTextEdit{
                id: endminute
                width: 100
                color: "grey";
                inputMethodHints: Qt.ImhTime | Qt.ImhDigitsOnly;
                //inputMask: "99";
                validator: IntValidator{bottom: 0; top: 59;}
                indicate_error: !acceptableInput;
                horizontalAlignment: TextEdit.AlignHCenter;
                text: tominute;
                onTextChanged: {
                    if(acceptableInput){
                        tominute = text;
                        stopChanged();
                    }
                }
            }
        }
    }
}


