import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12


Label {
    color: lkpalette.base_white;
    font.pointSize: lkfont.sizeNormal;
    linkColor: lkpalette.signalgreen;
    onLinkActivated: function(link){
        Qt.openUrlExternally(link)
    }
}
