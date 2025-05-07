import QtQuick.Layouts 1.12
import QtQuick 2.15
import QtQuick.Controls 2.12

Rectangle {
    id: backgroundRect
    height: 60
    color: lkpalette.base_extra_dark
    radius: 20
    border.color: indicate_error ? "red" : lkpalette.base_extra_dark
    Layout.fillWidth: true
    border.width: 2

    property alias headline: placeholder.text
    property alias text: textInput.text
    property alias font: textInput.font
    property alias inputMethodHints: textInput.inputMethodHints
    property alias echoMode: textInput.echoMode
    property alias validator: textInput.validator
    property bool indicate_error: false
    property alias acceptableInput: textInput.acceptableInput
    property alias passwordMaskDelay: textInput.passwordMaskDelay

    signal textEdited(string text)
    signal valueChanged()
    signal valueAccepted()

    onFocusChanged: {
        if (focus) {
            textInput.forceActiveFocus()
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.margins: 20
        contentWidth: textInput.width
        contentHeight: height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        interactive: false  // Disable user interaction with the Flickable

        TextInput {
            id: textInput
            width: Math.max(implicitWidth, flickable.width)
            height: flickable.height
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
            color: lkpalette.base_white
            focus: true
            
            onTextChanged: {
                placeholder.visible = text.length === 0
                // Ensure the cursor is visible when typing
                ensureVisible(cursorRectangle)
            }
            onTextEdited: {
                backgroundRect.textEdited(text)
            }
        }
    }

    // Function to ensure the cursor is visible
    function ensureVisible(r) {
        if (flickable.contentX >= r.x)
            flickable.contentX = r.x
        else if (flickable.contentX + flickable.width <= r.x + r.width)
            flickable.contentX = r.x + r.width - flickable.width
    }

    Text {
        id: placeholder
        text: "Enter text here..."
        color: lkpalette.base_grey
        anchors.fill: parent
        anchors.margins: 20
        font.pixelSize: 20
        visible: textInput.text.length === 0
        verticalAlignment: Text.AlignVCenter
    }
}
