import QtQuick
import QtMultimedia
import QZXing 3.3

Item {
    signal qrcode_found(var tag);


    // HeaderBar{
    //     id: qrHeader
    //     headText: qsTr("Scan QR Code")
    // }

    Text{
        anchors.top: parent.top
        //anchors.top: qrHeader.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.margins: 30;
        text: qsTr("Scan the QR-code on the charger");
        color: lkpalette.base_white;
        font.pointSize: 16;
        font.bold: true;
        font.italic: true;
        z: 10;
    }

    MediaDevices {
        id: mediaDevices

        Component.onCompleted: {
//            console.log(JSON.stringify(defaultVideoInput))
//            console.log(JSON.stringify( videoInputs));
        }
    }

    CaptureSession {

        camera: Camera
        {
            id:camera
            active: true;
            focusMode: Camera.FocusModeAutoNear
            cameraDevice: mediaDevices.defaultVideoInput

        }
        videoOutput: videoOutput
    }

    VideoOutput
    {
        id: videoOutput
        anchors.top: parent.top
        //anchors.top: qrHeader.bottom;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left
        anchors.right: parent.right
        fillMode: VideoOutput.PreserveAspectCrop
        Rectangle {
            id: captureZone
            color: "transparent"
            width: parent.width / 2
            height: parent.height / 2
            anchors.centerIn: parent
        }

        Rectangle{
            id: topborder;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.top: parent.top;
            anchors.bottom: captureZone.top;
            opacity: 0.5;
            color: "black";
        }
        Rectangle{
            id: bottomborder;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.top: captureZone.bottom;
            anchors.bottom: parent.bottom;
            opacity: 0.5;
            color: "black";
        }
        Rectangle{
            id: leftborder;
            anchors.left: parent.left;
            anchors.right: captureZone.left;
            anchors.top: topborder.bottom;
            anchors.bottom: bottomborder.top;
            opacity: 0.5;
            color: "black";
        }
        Rectangle{
            id: rightborder;
            anchors.left: captureZone.right;
            anchors.right: parent.right;
            anchors.top: topborder.bottom;
            anchors.bottom: bottomborder.top;
            opacity: 0.5;
            color: "black";
        }

        Rectangle{
            width: captureZone.width + border.width + (border.width/2 + 0.5);
            height: captureZone.height + border.width + (border.width/2 + 0.5);
            anchors.centerIn: captureZone;
            color: "transparent";
            border.width: 5;
            border.color: "white";
            radius: 15;
        }
    }


    QZXingFilter
    {
        id: zxingFilter
        videoSink: videoOutput.videoSink

        captureRect: {
            videoOutput.sourceRect;
            return Qt.rect(videoOutput.sourceRect.width * videoOutput.captureRectStartFactorX,
                           videoOutput.sourceRect.height * videoOutput.captureRectStartFactorY,
                           videoOutput.sourceRect.width * videoOutput.captureRectFactorWidth,
                           videoOutput.sourceRect.height * videoOutput.captureRectFactorHeight)
        }

        decoder {
            enabledDecoders: QZXing.DecoderFormat_QR_CODE

            onTagFound: function(tag){
                qrcode_found(tag);
            }

            tryHarder: false
        }
    }
    onVisibleChanged: {
        if(!visible){
            camera.active = false;
        }
    }
}
