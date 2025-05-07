import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Item{
    property alias start : ts.starttime;
    property alias interval : ts.interval;
    property alias days: ts.days;

    signal cancel();
    signal done();

    Timesetter{
        id: ts;
    }

    RowLayout{
        id: buttons;
        width: parent.width;
        height: 100;
        anchors.bottom: parent.bottom;
        LKButton{
            text: "Add";
            Layout.fillWidth: true;
            Layout.fillHeight: true;
            onClicked: done();
        }
    }
}

