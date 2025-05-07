import QtQuick 2.13
import QtQuick.Window 2.13
import QtQml 2.12
import QtQuick.Layouts 1.12

Item {
    function set_elabsed_text(start, stop){
        if(!start) return "--:--";
        if(!stop) return "--:--";
        var time = (stop - start);
        var sec = time/1000;
        var min = parseInt(sec / 60);
        sec -= min * 60;
        sec = parseInt(sec);

        var hour = parseInt(min / 60);
        min -= hour * 60;
        if(sec < 10) sec = "0" + sec;
        if(min < 10) min = "0" + min;
        if(hour < 10) hour = "0" + hour;
        return hour + ":" + min + ":" + sec;
    }

    Layout.preferredHeight: cl.implicitHeight + 10;

    ColumnLayout{
        id: cl;
        LKLabel{
            font.pointSize: lkfont.sizeLarge;
            font.bold: true;
            text: qsTr("Elabsed") + ":";
        }

        LKLabel{
            text: set_elabsed_text(orderstart*1000, orderstop*1000); //"--:--";

            Timer{
                interval: 1000;
                running: charging;
                repeat: true;
                onTriggered: {
                    if(!orderstart) return;
                    parent.text = set_elabsed_text(orderstart*1000, orderstop*1000 ? orderstop*1000 : Date.now());
                }
            }
        }
    }

    LKSeperator{
    }
}
