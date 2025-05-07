import QtQuick
import QtQuick.Controls

Item{
    id: flic;
    property Item content: null
    property bool refreshEnable: false;
    signal updateView();

    Component.onCompleted: {
        if (content) {
            content.parent = contentItem
        }
    }

    Item{
        id: updatenotificationicon
        width: 50;
        height: 50;
        anchors.horizontalCenter: parent.horizontalCenter;

        z: -1
        opacity: Math.min(1.0, flickable.contentY / (-1*flickable.releaseTreshold))

        LKIcon{ //Down arrow
            anchors.fill: parent;
            text: "\uE821";
            visible: !fetch_spinner.visible;
        }
        LKSpinner{
            id: fetch_spinner;
            anchors.centerIn: parent;
            font.pointSize: 20;
        }
    }

    Flickable {
        id: flickable
        interactive: true;
        boundsBehavior: flic.refreshEnable ? Flickable.DragOverBounds : Flickable.StopAtBounds;
        contentHeight: contentItem.height;// + contentItem.topMargin + contentItem.bottomMargin;
        anchors.fill: parent;

        clip: true;

        ScrollBar.vertical: LKScrollBar{
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }

        // Container for the content
        Item {
            id: contentItem
            width: parent.width
            height: flic.content ? flic.content.implicitHeight : 0;
        }

        property real pullThreshold: 70
        property real releaseTreshold: 40
        property bool isPulling: false
        property bool canTrigger: true
        property bool isWaiting: false

        Timer {
            id: delayTimer
            interval: 500
            onTriggered: {
                flickable.isWaiting = false
                // Animate the rest of the way up
                bounceBackAnimation.start()
            }
        }

        NumberAnimation {
            id: bounceBackAnimation
            target: flickable
            property: "contentY"
            to: 0
            duration: 300
            easing.type: Easing.OutQuad
        }

        onDragEnded:{
            if(!canTrigger){
                isWaiting = true;
            }
        }
        onDragStarted:{
            fetch_spinner.running = false;
            updatenotificationicon.visible = true;
        }

        onContentYChanged: {           
            if(contentHeight < height){
                if(contentY > 0){
                    contentY = 0;
                    fetch_spinner.running = false;
                    updatenotificationicon.visible = false;
                }
            }
            else{
                if(contentY + height > contentHeight){
                    contentY = contentHeight - height;
                }
            }

            // Check if pulling down past the top
            if (contentY < 0) {
                isPulling = true
                if (Math.abs(contentY) > pullThreshold && canTrigger) {
                    canTrigger = false  // Prevent multiple triggers
                    onPullDownTriggered()
                    fetch_spinner.running = true;
                }
                else if(isWaiting){
                    if(Math.abs(contentY) < releaseTreshold){
                        contentY = releaseTreshold * -1;
                        delayTimer.start();
                    }
                }
            } else {
                isPulling = false
                canTrigger = true  // Re-enable trigger when released
                isWaiting = false;
            }
        }

        function onPullDownTriggered() {
            updateView();
        }
    }
}
