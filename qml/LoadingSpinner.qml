import QtQuick 2.15

Item {
    width: 100
    height: 100
    visible: true

    // White Circular Background
    Rectangle {
        id: background
        width: parent.width
        height: parent.height
        color: "white"
        radius: width / 2
        anchors.centerIn: parent


    }

    LKIcon{
        text: "\uE820";
        anchors.centerIn: parent
        color: lkpalette.base
        font.pointSize: lkfont.sizeLarger;
    }

    // Thin Line with Circular Ends
    Canvas {
        id: spinnerLine
        anchors.fill: parent
        rotation: 0

        onPaint: {
            var ctx = getContext("2d");
            var centerX = width / 2;
            var centerY = height / 2;
            var radius = Math.min(centerX, centerY) - 13;
            var startAngle = 0;
            var endAngle = Math.PI * 1.5; // Small angle for thin line

            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, startAngle, startAngle + endAngle);
            ctx.lineWidth = 6; // Thin line
            ctx.lineCap = "round"; // Circular ends
            ctx.strokeStyle = "#2e4d59"; // Line color, change as needed
            ctx.stroke();
        }

        // Rotation Animation
        NumberAnimation on rotation {
            from: 0
            to: 360
            duration: 1500
            loops: Animation.Infinite
            running: true
        }
    }
}
