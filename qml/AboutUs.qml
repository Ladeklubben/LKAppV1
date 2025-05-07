import QtQuick
import QtQuick.Layouts

Item {
    Component.onCompleted: {
        header.headText = qsTr("About Us");
    }

    ColumnLayout {
        spacing: 20
        anchors.fill: parent
        anchors.margins: margin

        LKIcon{
            id: logo;
            text: "\uE80A";
            font.pointSize: 60;
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            Layout.fillWidth: true
            color: lkpalette.base_extra_dark
            radius: 20
            Layout.preferredHeight: gridLayout.implicitHeight + 2 * margin

            GridLayout {
                id: gridLayout
                columns: 2
                columnSpacing: 20
                rowSpacing: 20
                anchors.fill: parent
                anchors.margins: margin
                LKLabel {
                    text: qsTr("Version") + ":"
                    font.bold: true
                    font.pointSize: lkfont.sizeMediumSmall
                }
                LKLabel {
                    text: Qt.application.version
                    font.pointSize: lkfont.sizeMediumSmall
                }
                LKLabel {
                    text: qsTr("Support") + ":"
                    font.bold: true
                    font.pointSize: lkfont.sizeMediumSmall
                }
                LKLabel {
                    text: "<a href='mailto:info@ladeklubben.dk'>info@ladeklubben.dk</a>"
                    font.pointSize: lkfont.sizeMediumSmall
                }
                LKLabel {
                    text: qsTr("Company") + ":"
                    font.bold: true
                    font.pointSize: lkfont.sizeMediumSmall
                    Layout.alignment: Qt.AlignTop
                }
                LKLabel {
                    text: "Ladeklubben ApS\n" +
                          "Ellegårdvej 25C\n" +
                          "6400 Sønderborg"
                    color: "White"
                    font.pointSize: lkfont.sizeMediumSmall
                    lineHeight: 1.5
                }
                LKLabel {
                    text: qsTr("Website") + ":"
                    font.bold: true
                    font.pointSize: lkfont.sizeMediumSmall
                    Layout.alignment: Qt.AlignTop
                }
                LKLabel {
                    text: '<a href="https://ladeklubben.dk">https://ladeklubben.dk</a>'
                    color: "White"
                    font.pointSize: lkfont.sizeMediumSmall
                    lineHeight: 1.5
                }
                LKLabel {
                    text: qsTr("Based on") + ":"
                    font.bold: true
                    font.pointSize: lkfont.sizeMediumSmall
                    Layout.alignment: Qt.AlignTop
                }
                LKLabel {
                    text: "QT " + qtversion;
                    font.pointSize: lkfont.sizeMediumSmall
                    lineHeight: 1.5
                }
                LKLabel {
                    text: qsTr("Extra libs") + ":"
                    font.bold: true
                    font.pointSize: lkfont.sizeMediumSmall
                    Layout.alignment: Qt.AlignTop
                }
                LKLabel {
                    text: '<a href="https://github.com/ftylitak/qzxing">QZxing</a><br>' +
                          '<a href="https://www.openstreetmap.org">OpenStreetmap</a>'
                    lineHeight: 1.5
                }
            }
        }
    }
}
