import QtQuick

Item {
    id: rotpage;

    property Component rotitem;

    Item{
        id: rotcanvas;
        property bool fullscreen: false;
        property int height_normal: 200;
        property int duration: 500;

        onFullscreenChanged: {
            if(fullscreen) {
                rotcanvas.state = "rotated"
            }
            else{
                rotcanvas.state = "normal"
            }
        }

        //color: "green";
        width: parent.width;
        height: height_normal;

        transformOrigin: Item.BottomLeft;

        states: [State {
            name: "rotated"
            PropertyChanges { target: rotcanvas; rotation: 90 }
        },
            State {
            name: "normal"
            PropertyChanges { target: rotcanvas; rotation: 0 }
            }
        ]
        transitions: [
            Transition {
            to: "rotated";
            RotationAnimation { duration: duration; direction: RotationAnimation.Clockwise }
            PropertyAnimation { target: rotcanvas;  duration: duration; property: "width"; to: rotpage.height;}
            PropertyAnimation { target: rotcanvas;  duration: duration; property: "height"; to: rotpage.width;}
            PropertyAnimation { target: rotcanvas;  duration: duration; property: "y"; to: rotcanvas.y - rotcanvas.width;}
        },
           Transition {
            to: "normal";
            RotationAnimation { duration: duration; direction: RotationAnimation.Counterclockwise }
            PropertyAnimation { target: rotcanvas;  duration: duration; property: "width"; to: rotpage.width;}
            PropertyAnimation { target: rotcanvas;  duration: duration; property: "height"; to: rotcanvas.height_normal;}
            PropertyAnimation { target: rotcanvas;  duration: duration; property: "y"; to: 0;}
            }
        ]

        Loader{
            anchors.fill: parent;
            sourceComponent: rotitem;
        }


        Rectangle{
            //z: 500;
            width: 50;
            height: width;
            radius: height/2;
            color: "white"
            opacity: 0.5
            anchors {
                top: parent.top;
                right: parent.right;
                margins: 5;
            }
            LKIconButton{
                anchors.fill: parent;
                text: rotcanvas.fullscreen ? "\uE81B" : "\uE81A"
                color: "black";
                onClicked: {
                    rotcanvas.fullscreen = !rotcanvas.fullscreen;
                }
            }
        }
    }
}
