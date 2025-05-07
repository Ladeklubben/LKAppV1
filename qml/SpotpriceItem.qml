import QtQuick 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    id: root
    height: contentColumn.implicitHeight + 10 // Add some padding

    ColumnLayout {
        id: contentColumn
        anchors {
            fill: parent
            margins: 5
        }
        spacing: 5

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Label {
                Layout.preferredWidth: root.width / 3
                font.pointSize: 14
                text: Timestamp
                color: "black"
                elide: Text.ElideRight
            }

            RowLayout {
                Layout.preferredWidth: root.width / 3
                spacing: 3

                Label {
                    font.pointSize: 14
                    text: (Costprice_VAT - parseFloat(EnergyTax_tariff) * 0.0125).toFixed(2)
                    color: "black"
                }

                Label {
                    font.pointSize: 14
                    text: "DKK"
                    color: "black"
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 3

                Label {
                    font.pointSize: 14
                    text: Costprice_VAT
                    color: "black"
                }

                Label {
                    font.pointSize: 14
                    text: "DKK"
                    color: "black"
                }
            }
        }

        GridLayout {
            id: details
            visible: false
            columns: 4
            Layout.fillWidth: true

            // First row
            Label {
                font.pointSize: 8
                text: qsTr("Spotprice") + ":"
                color: "grey"
            }

            Label {
                font.pointSize: 8
                text: Spotprice_tariff
                color: "grey"
                Layout.fillWidth: true
            }

            Label {
                font.pointSize: 8
                text: qsTr("Energinet") + ":"
                color: "grey"
            }

            Label {
                font.pointSize: 8
                text: Energynet_tariff
                color: "grey"
                Layout.fillWidth: true
            }

            // Second row
            Label {
                font.pointSize: 8
                text: qsTr("Distribution") + ":"
                color: "grey"
            }

            Label {
                font.pointSize: 8
                text: Distribution_tariff
                color: "grey"
                Layout.fillWidth: true
            }

            Label {
                font.pointSize: 8
                text: qsTr("Electricity tax") + ":"
                color: "grey"
            }

            Label {
                font.pointSize: 8
                text: EnergyTax_tariff
                color: "grey"
                Layout.fillWidth: true
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            details.visible = !details.visible
        }
    }
}
