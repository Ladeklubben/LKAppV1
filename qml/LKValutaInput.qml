import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQml

TextInput {
    id: input
    color: lkpalette.base_white
    font.pointSize: lkfont.sizeNormal

    property string priceText: "0,00"  // Store as text instead of number
    property double minimum: 0
    property bool internalChange: false

    maximumLength: 10
    inputMethodHints: Qt.ImhFormattedNumbersOnly
    validator: RegularExpressionValidator {
        regularExpression: /^[0-9]*[,.]?[0-9]{0,2}$/
    }
    horizontalAlignment: TextInput.AlignRight
    selectByMouse: true
    mouseSelectionMode: TextInput.SelectCharacters
    selectionColor: lkpalette.seperator

    // Format the display text
    function updateDisplayText() {
        if (!activeFocus) {
            internalChange = true

            // Parse the stored text value to a number for formatting
            let num = Number.fromLocaleString(Qt.locale(), priceText) || 0

            // Format with locale settings (adds thousand separators if needed)
            text = num.toLocaleString(Qt.locale(), 'f', 2)
            internalChange = false
        }
    }

    // Expose a numeric value for calculations if needed
    function getNumericValue() {
        return Number.fromLocaleString(Qt.locale(), priceText) || 0
    }

    // Set the price from a numeric value (for backward compatibility)
    function setFromNumericValue(value) {
        priceText = value.toLocaleString(Qt.locale(), 'f', 2).replace(".", ",")
    }

    onPriceTextChanged: {
        updateDisplayText()
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            internalChange = true
            text = priceText  // Just show the raw stored text
            internalChange = false
            selectAll()
        } else {
            // When focus is lost, store the current value and format for display
            if (!internalChange && acceptableInput) {
                priceText = text.replace(".", ",")  // Standardize on comma as decimal separator
            }
            updateDisplayText()
        }
    }

    onTextEdited: {
        if (!internalChange && acceptableInput) {
            priceText = text.replace(".", ",")  // Standardize on comma
        }
    }

    onAcceptableInputChanged: {
        if (!internalChange && acceptableInput) {
            priceText = text.replace(".", ",")  // Standardize on comma
        }
    }

    Keys.onReturnPressed: event => {
        focus = false
    }

    LKSeperator {
        color: input.acceptableInput ? lkpalette.seperator : lkpalette.error
    }

    Component.onCompleted: {
        updateDisplayText()
    }
}
