import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
//import Qt.labs.calendar 1.0
 import QtQuick.Controls
import QtQml 2.15

Item
{
    id: dp;

    signal ok
    signal cancel
    property var date: new Date(); //new Date(calendar.currentYear, calendar.currentMonth, calendar.currentDay);

    Item {
        id: mainForm
        height: cellSize * 12
        width: cellSize * 8
        property double mm: Screen.pixelDensity
        property double cellSize: parent.width/8; // mm * 7
        property int fontSizePx: cellSize * 0.32
        clip: true

        QtObject {
            id: palette
            property color primary: lkpalette.base;
            property color primary_dark: lkpalette.base_dark;
            property color primary_light: lkpalette.base_light;
            property color primary_text: lkpalette.text;
            property color secondary_text: lkpalette.base_grey;
            property color icons: lkpalette.signalgreen;
            property color divider: lkpalette.seperator;
        }

        Item {
            id: selectedYear
            anchors {
                top: parent.top
            }
            height: mainForm.cellSize * 1
            width: parent.width;
            Text {
                id: yearTitle
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: mainForm.fontSizePx * 1.7
                color: palette.primary_dark;
                text: calendar.currentYear
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    yearsList.show();
                }
            }
        }


        ListView {
            id: calendar
            anchors {
                top: selectedYear.bottom
                bottom: parent.bottom;
                left: parent.left
                right: parent.right
                leftMargin: mainForm.cellSize * 0.5
                rightMargin: mainForm.cellSize * 0.5
            }
            visible: true
            z: 1

            snapMode: ListView.SnapToItem
            orientation: ListView.Horizontal
            spacing: mainForm.cellSize
            model: CalendarModel {
                id: calendarModel
                from: new Date(date.getFullYear(), 0, 1);
                to: new Date(date.getFullYear(), 11, 31);
                function  setYear(newYear) {
                    if (calendarModel.from.getFullYear() > newYear) {
                        calendarModel.from = new Date(newYear, 0, 1);
                        calendarModel.to = new Date(newYear, 11, 31);
                    } else {
                        calendarModel.to = new Date(newYear, 11, 31);
                        calendarModel.from = new Date(newYear, 0, 1);
                    }
                    calendar.currentYear = newYear;
                    calendar.goToLastPickedDate();
                    dp.setCurrentDate();
                }
            }

            property int currentDay: date.getDate()
            property int currentMonth: date.getMonth()
            property int currentYear: date.getFullYear()
            property int week: date.getDay()


            delegate: Item {
                height: mainForm.cellSize * 8.5 //6 - на строки, 1 на дни недели и 1.5 на подпись
                width: mainForm.cellSize * 7
                Rectangle {
                    id: monthYearTitle
                    anchors {
                        top: parent.top
                    }
                    height: mainForm.cellSize * 1.3
                    width: calendar.width
                    color: "transparent";

                    Text {
                        anchors.centerIn: parent
                        font.pixelSize: mainForm.fontSizePx * 1.2
                        text: datetime.monthstring[model.month];
                        color: palette.primary_text
                    }
                }

                DayOfWeekRow {
                    id: weekTitles
                    //Layout.column: 1
                    //locale: monthGrid.locale
                    anchors {
                        top: monthYearTitle.bottom
                    }
                    height: mainForm.cellSize
                    width: parent.width
                    delegate: Text {
                        text: model.shortName.toUpperCase()
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: mainForm.fontSizePx
                        color: lkpalette.text;
                    }
                }

                MonthGrid {
                    id: monthGrid
                    month: model.month
                    year: model.year

                    spacing: 0
                    anchors {
                        top: weekTitles.bottom
                    }
                    width: mainForm.cellSize * 7
                    height: mainForm.cellSize * 6

                    //locale: Qt.locale("en_US")
                    //locale: Qt.locale("da_DK");
                    delegate: Rectangle {
                        height: mainForm.cellSize
                        width: mainForm.cellSize
                        radius: height * 0.5
                        property bool highlighted: enabled && model.day == calendar.currentDay && model.month == calendar.currentMonth

                        enabled: model.month === monthGrid.month
                        color: enabled && highlighted ? palette.icons : "transparent"; //palette.primary_text; //"white"

                        Text {
                            anchors.centerIn: parent
                            text: model.day
                            font.pixelSize: mainForm.fontSizePx
                            scale: highlighted ? 1.25 : 1
                            Behavior on scale { NumberAnimation { duration: 150 } }
                            visible: parent.enabled
                            color: palette.primary_text; //parent.highlighted ? palette.primary_text : palette.primary_dark; //"black"
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                calendar.currentDay = model.date.getDate();
                                calendar.currentMonth = model.date.getMonth();
                                calendar.week = model.date.getDay();
                                calendar.currentYear = model.date.getFullYear();
                                dp.setCurrentDate();
                            }
                        }
                    }
                }
            }

            onCurrentIndexChanged: {
                console.log(currentIndex)
            }

            Component.onCompleted: {
                goToLastPickedDate()
            }
            function goToLastPickedDate() {
                calendar.positionViewAtIndex(calendar.currentMonth, ListView.SnapToItem)
            }
        }

        ListView {
            id: yearsList
            anchors.fill: calendar
            orientation: ListView.Vertical
            visible: false
            z: calendar.z

            property int currentYear
            property int startYear: 2015
            property int endYear : new Date().getFullYear() + 2;
            model: ListModel {
                id: yearsModel
            }

            delegate: Item {
                width: yearsList.width
                height: mainForm.cellSize * 1.5
                Text {
                    anchors.centerIn: parent
                    font.pixelSize: mainForm.fontSizePx * 1.5
                    text: name
                    scale: index == yearsList.currentYear - yearsList.startYear ? 1.5 : 1
                    color: palette.primary_dark
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        calendarModel.setYear(yearsList.startYear + index);
                        yearsList.hide();
                    }
                }
            }

            Component.onCompleted: {
                for (var year = startYear; year <= endYear; year ++)
                    yearsModel.append({name: year});
            }
            function show() {
                visible = true;
                calendar.visible = false
                selectedYear.visible = false;
                currentYear = calendar.currentYear
                yearsList.positionViewAtIndex(currentYear - startYear, ListView.SnapToItem);
            }
            function hide() {
                visible = false;
                calendar.visible = true;
                selectedYear.visible = true;
            }
        }
    }

    function setCurrentDate() {
        dp.date = new Date(calendar.currentYear, calendar.currentMonth, calendar.currentDay);
    }

    //For some reason we need to wait before we update actual view
    Timer{
        interval: 5;
        running: true;
        repeat: false;
        onTriggered: {
            calendar.goToLastPickedDate();
        }
    }
}
