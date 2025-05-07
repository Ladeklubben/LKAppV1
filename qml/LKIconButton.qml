import QtQuick

MouseArea {
    property alias text: icon.text;
    property alias pointsize: icon.font.pointSize;
    property alias color: icon.color;
    property bool spin_after_click: false;
    property alias spin_running: spinner.running;
    LKIcon{
        id: icon;
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter;
        anchors.fill: parent;
        fontSizeMode: Text.Fit;
        minimumPixelSize: lkfont.sizeSmall;
        font.pointSize: 300
        opacity: spinner.running ? 0.5 : 1;
    }
    onClicked: {
        if(spin_after_click) spinner.running = true;
    }

    LKSpinner{
        id: spinner;
        running: false;
        anchors.centerIn: parent;
    }
}
