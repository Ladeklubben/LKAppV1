import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {
    property string headline
    property alias priceText: pricetag.priceText
    property double minimum: 0.0
    property alias helpertext: helpericon.helpertext
    property alias accepted: pricetag.acceptableInput

    property bool changed: false
    onPriceTextChanged: {
        changed = true
    }

    // For backward compatibility - get numeric value
    function getPrice() {
        return pricetag.getNumericValue()
    }

    // For backward compatibility - set from numeric value
    function setFromNumericValue(value) {
        pricetag.setFromNumericValue(value)
    }

    height: 50
    spacing: 5

    RowLayout {
        id: lineinfo
        Layout.fillWidth: false
        Layout.fillHeight: true
        spacing: 10
        LKLabel {
            text: headline
        }
        LKHelp {
            id: helpericon
            Layout.fillHeight: true
            Layout.preferredWidth: 30
            pointsize: lkfont.sizeNormal
            onClicked: {
                alertbox.setSource("LKAlertBox.qml", {"message": helpertext})
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Item {   //Just a fillup item
            Layout.fillWidth: true
        }
        LKValutaInput {
            Layout.fillWidth: true
            Layout.maximumWidth: 100
            horizontalAlignment: TextInput.AlignHCenter
            id: pricetag
        }
        LKLabel {
            id: valuta
            Layout.fillWidth: false
            text: "DKK/kWh"
            leftPadding: 5
        }
    }

    Component.onCompleted: {
        changed = false
    }
}
