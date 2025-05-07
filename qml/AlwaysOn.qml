import QtQuick 2.12
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

ScheduleWidget{
    // geturi: '/alwayson'
    // edituri: '/alwayson';
    schedule_interface: lkinterface.schedule_alwayson;
    Component.onCompleted: {
        header.headText = qsTr("ALWAYS-ON hours")
    }
}

