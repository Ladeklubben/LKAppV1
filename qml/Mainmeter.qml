import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    // Properties for dynamic data
    property int liveUsageWatts: 0
    property real phaseL1Current: 0
    property real phaseL2Current: 0
    property real phaseL3Current: 0
    property int maxCurrentPerPhase: 25 // Default max current per phase (25A), set this from outside
    property string lastUpdated: "Ikke opdateret" // Property for timestamp

    // Calculated properties for percentage values
    property real phaseL1Percentage: Math.min(100, (phaseL1Current / maxCurrentPerPhase) * 100)
    property real phaseL2Percentage: Math.min(100, (phaseL2Current / maxCurrentPerPhase) * 100)
    property real phaseL3Percentage: Math.min(100, (phaseL3Current / maxCurrentPerPhase) * 100)

    // Function to update data from JSON
    function updateFromJson(ok, jsonData) {
        if(!ok) return;
        try {
            const data = jsonData; //JSON.parse(jsonData);

            // Update power usage in Watts - now using totals.total_power_import
            liveUsageWatts = Math.round(data.totals.total_power_import * 1000); // Convert kW to W

            // Get phase currents directly from the current array
            phaseL1Current = data.current[0];
            phaseL2Current = data.current[1];
            phaseL3Current = data.current[2];

            // Update timestamp - converting UNIX timestamp to readable format
            const date = new Date(data.timestamp * 1000);
            const hours = date.getHours().toString().padStart(2, '0');
            const minutes = date.getMinutes().toString().padStart(2, '0');
            const seconds = date.getSeconds().toString().padStart(2, '0');
            lastUpdated = `${hours}:${minutes}:${seconds}`;
        } catch (e) {
            console.error("Error parsing JSON data:", e);
        }
    }

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: "#182B34" // Updated background color
    }

    Column {
        id: mainColumn
        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.12 // Adjusted to match phone display
        spacing: parent.height * 0.02

        // Live Usage Panel
        Rectangle {
            id: liveUsagePanel
            width: parent.width
            height: parent.width * 0.3
            radius: 16
            color: "transparent"
            border.color: "#3E8A9C"
            border.width: 1

            Rectangle {
                id: liveUsageBackground
                anchors.fill: parent
                radius: 16
                z: -1

                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#3E8A9C" }
                    GradientStop { position: 1.0; color: "#152F36" }
                }
            }

            Column {
                anchors.centerIn: parent
                spacing: 10

                Text {
                    id: liveUsageTitle
                    text: "Live Usage"
                    color: "#FFFFFF"
                    font {
                        pixelSize: 18
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 2

                    Text {
                        id: liveUsageValue
                        text: liveUsageWatts
                        color: "#FFFFFF"
                        font {
                            pixelSize: 42
                            bold: true
                        }
                    }

                    Text {
                        id: liveUsageUnit
                        text: "W"
                        color: "#FFFFFF"
                        font {
                            pixelSize: 24
                        }
                        anchors.baseline: liveUsageValue.baseline
                    }
                }
            }
        }

        // Phase Overview Panel
        Rectangle {
            id: phaseOverviewPanel
            width: parent.width
            height: parent.width * 0.6
            radius: 16
            color: "#152F36"
            border.color: "#3E8A9C"
            border.width: 1

            Column {
                id: phaseOverviewColumn
                width: parent.width * 0.9
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 20
                spacing: 20

                Text {
                    id: phaseOverviewTitle
                    text: "Fase oversigt"
                    color: "#FFFFFF"
                    font {
                        pixelSize: 24
                        bold: true
                    }
                }



                // Phase 1 Bar
                Column {
                    width: parent.width
                    spacing: 8

                    Rectangle {
                        id: phase1Container
                        width: parent.width
                        height: 40
                        radius: 20
                        color: "#2E4D59"
                        clip: true

                        Rectangle {
                            id: phase1Bar
                            width: Math.max(parent.width * (phaseL1Percentage / 100), parent.radius) // Ensure minimum width equals radius (same as height)
                            height: 40
                            radius: 20
                            color: phaseL1Percentage > 90 ? "#FF4D4D" : "#3E8A9C" // Red if near capacity

                            Behavior on width {
                                NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
                            }
                        }

                        Text {
                            id: phase1Label
                            text: "L1"
                            color: "#FFFFFF"
                            font {
                                pixelSize: 16
                                bold: true
                            }
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 26
                        }

                        Text {
                            id: phase1Value
                            text: phaseL1Current.toFixed(1) + " A"
                            color: "#FFFFFF"
                            font {
                                pixelSize: 16
                            }
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 18
                        }
                    }

                    // Phase 2 Bar
                    Rectangle {
                        id: phase2Container
                        width: parent.width
                        height: 40
                        radius: 20
                        color: "#2E4D59"
                        clip: true

                        Rectangle {
                            id: phase2Bar
                            width: Math.max(parent.width * (phaseL2Percentage / 100), parent.radius) // Ensure minimum width equals radius (same as height)
                            height: 40
                            radius: 20
                            color: phaseL2Percentage > 90 ? "#FF4D4D" : "#3E8A9C" // Red if near capacity

                            Behavior on width {
                                NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
                            }
                        }

                        Text {
                            id: phase2Label
                            text: "L2"
                            color: "#FFFFFF"
                            font {
                                pixelSize: 16
                                bold: true
                            }
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 26
                        }

                        Text {
                            id: phase2Value
                            text: phaseL2Current.toFixed(1) + " A"
                            color: "#FFFFFF"
                            font {
                                pixelSize: 16
                            }
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 18
                        }
                    }

                    // Phase 3 Bar
                    Rectangle {
                        id: phase3Container
                        width: parent.width
                        height: 40
                        radius: 20
                        color: "#2E4D59"
                        clip: true

                        Rectangle {
                            id: phase3Bar
                            width: Math.max(parent.width * (phaseL3Percentage / 100), parent.radius) // Ensure minimum width equals radius (same as height)
                            height: 40
                            radius: 20
                            color: phaseL3Percentage > 90 ? "#FF4D4D" : "#3E8A9C" // Red if near capacity

                            Behavior on width {
                                NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
                            }
                        }

                        Text {
                            id: phase3Label
                            text: "L3"
                            color: "#FFFFFF"
                            font {
                                pixelSize: 16
                                bold: true
                            }
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 26
                        }

                        Text {
                            id: phase3Value
                            text: phaseL3Current.toFixed(1) + " A"
                            color: "#FFFFFF"
                            font {
                                pixelSize: 16
                            }
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 18
                        }
                    }
                }
            }
        }
    }

    // Timestamp display in bottom right
    Text {
        id: timestampText
        text: "Opdateret: " + lastUpdated
        color: "#AAAAAA"  // Light gray color for subtle display
        font {
            pixelSize: 12  // Small text
        }
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
    }

    // Example of how to use with a Timer for testing
    Timer {
        interval: 2000
        running: true
        triggeredOnStart: true;
        repeat: true
        onTriggered: {
            lkinterface.installation.get_mainmeter("", updateFromJson);
        }
    }
}
