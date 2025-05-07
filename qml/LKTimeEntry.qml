import QtQuick
import QtQuick.Layouts


RowLayout{
    Layout.preferredWidth: 150;
    Layout.minimumWidth: 100;

    property var callback: function(){};

    property string minute;
    property string hour;

    property bool valid: endhour.acceptableInput && endminute.acceptableInput;

    onHourChanged: {
        if(endminute.acceptableInput)
            callback(hour, minute);
    }
    onMinuteChanged: {
        if(endhour.acceptableInput)
            callback(hour, minute);
    }

    height: parent.height;
    spacing: 5;
    LKTextEdit{
        id: endhour;
        Layout.minimumWidth: 50;
        Layout.fillWidth: true;
        height: parent.height;
        headline: qsTr("Hour");
        headline_font_pointSize_large: lkfont.sizeNormal;
        color: lkpalette.base_white;
        inputMethodHints: Qt.ImhTime | Qt.ImhDigitsOnly;
        validator: IntValidator{bottom: 0; top: 23;}
        indicate_error: !acceptableInput;
        horizontalAlignment: TextEdit.AlignHCenter;
        text: hour;
        onTextChanged: {
            hour = text;
        }
    }
    LKLabel{
        Layout.minimumWidth: 25;
        Layout.fillWidth: false;
        height: parent.height;
        font.pointSize: lkfont.sizeLarge;
        text: ":";
        color: lkpalette.base_white;
        verticalAlignment: TextEdit.AlignVCenter;
        horizontalAlignment: TextEdit.AlignHCenter;
    }
    LKTextEdit{
        id: endminute
        headline: qsTr("Minute");
        headline_font_pointSize_large: lkfont.sizeNormal;
        Layout.fillWidth: true;
        Layout.minimumWidth: 50;
        height: parent.height;
        color: lkpalette.base_white;
        inputMethodHints: Qt.ImhTime | Qt.ImhDigitsOnly;
        validator: IntValidator{bottom: 0; top: 59;}
        indicate_error: !acceptableInput;
        horizontalAlignment: TextEdit.AlignHCenter;
        text: minute;
        onTextChanged: {
            minute = text;
        }
    }
}

