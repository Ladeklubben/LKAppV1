import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts

Item {
    // External property for the charging profile
    property var chargingProfile: null

    property real scaleFactor: Math.min(width / 800, height / 600)
    property bool isDragging: false
    property point lastPos
    property int highlightedPointIndex: -1
    property var dataPoints: []

    // Properties for time management
    property real startTime;
    property real endTime;

    function timeToSeconds(timeStr) {
        if (!timeStr) return Math.floor(Date.now() / 1000)

        try {
            const timestamp = Date.parse(timeStr)
            return isNaN(timestamp) ? Math.floor(Date.now() / 1000) : timestamp / 1000
        } catch (e) {
            console.error("Error parsing time:", e)
            return Math.floor(Date.now() / 1000)
        }
    }

    function formatTime(seconds) {
        let date = new Date(seconds * 1000)
        return date.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)
    }

    function formatDate(seconds) {
        let date = new Date(seconds * 1000)
        return date.toLocaleDateString(Qt.locale(), Locale.ShortFormat)
    }

    function roundToHour(timestamp) {
        return Math.floor(timestamp / 3600) * 3600
    }

    // Function to update chart data when profile changes
    function updateChartData() {
        // Clear existing data
        chargingSeries.clear()
        dataPoints = []

        startTime = timeToSeconds(chargingProfile.chargingSchedule.startSchedule)
        endTime = Math.max(startTime, Date.now() / 1000) + 43200;

        const TINY_OFFSET = 0.1
        let periods = chargingProfile.chargingSchedule.chargingSchedulePeriod

        // Validate periods array
        if (!Array.isArray(periods) || periods.length === 0) {
            console.warn("No valid charging schedule periods")
            return
        }

        // Find first non-zero charging period
        let firstChargingTime = startTime
        for (let period of periods) {
            if (period.limit > 0) {
                firstChargingTime = startTime + period.startPeriod
                break
            }
        }

        // Start axis display from one hour before the first charging time, aligned to hours
        const hourInSeconds = 3600
        const axisStartTime = Math.floor((firstChargingTime - hourInSeconds) / hourInSeconds) * hourInSeconds
        const sixHours = 6 * 3600 * 1000; // 6 hours in milliseconds

        axisX.min = new Date(axisStartTime * 1000)
        axisX.max = new Date(axisStartTime * 1000 + sixHours)

        // Update actual end time to allow scrolling forward
        endTime = Math.max(endTime, axisStartTime + (12 * 3600)) // Allow scrolling up to at least 12 hours ahead

        // Update data points and series
        for (let i = 0; i < periods.length; i++) {
            if (typeof periods[i].startPeriod !== 'number' ||
                typeof periods[i].limit !== 'number') {
                console.warn("Invalid period data at index", i)
                continue
            }

            let transitionTime = startTime + periods[i].startPeriod

            dataPoints.push({
                time: transitionTime,
                current: periods[i].limit
            })

            if (i > 0) {
                chargingSeries.append((transitionTime * 1000) - TINY_OFFSET, periods[i-1].limit)
            }
            chargingSeries.append(transitionTime * 1000, periods[i].limit)
        }

        chargingSeries.append(endTime * 1000, periods[periods.length - 1].limit)
    }

    // Monitor changes to the charging profile
    onChargingProfileChanged: {
        updateChartData()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20 * scaleFactor
        spacing: 20 * scaleFactor

        // Loading state or info box
        Rectangle {
            id: infoBox
            Layout.fillWidth: true
            Layout.preferredHeight: 60 * scaleFactor
            color: lkpalette.base
            radius: 4 * scaleFactor
            visible: true

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 4 * scaleFactor

                Text {
                    Layout.alignment: Qt.AlignCenter
                    text: {
                        if (!chargingProfile) return qsTr("Loading charging profile...")
                        return highlightedPointIndex >= 0 ?
                              qsTr("Current") +": " + dataPoints[highlightedPointIndex].current + " A" :
                              qsTr("Click an edge to see details")
                    }
                    font.pixelSize: lkfont.sizeMediumSmall
                    color: lkpalette.base_white
                    opacity: (!chargingProfile || highlightedPointIndex < 0) ? 0.7 : 1.0
                }

                Text {
                    Layout.alignment: Qt.AlignCenter
                    text: {
                        if (!chargingProfile) return qsTr("Please wait...")
                        return highlightedPointIndex >= 0 ?
                              qsTr("Time") + ": " + formatTime(dataPoints[highlightedPointIndex].time) +
                              " " + formatDate(dataPoints[highlightedPointIndex].time) : ""
                    }
                    font.pixelSize: lkfont.sizeMediumSmall
                    color: lkpalette.base_white
                    opacity: (!chargingProfile || highlightedPointIndex < 0) ? 0.7 : 1.0
                }
            }
        }

        // Chart view with loading state
        ChartView {
            id: chartView
            Layout.fillWidth: true
            Layout.fillHeight: true
            antialiasing: true
            legend.visible: false
            dropShadowEnabled: false
            backgroundColor: lkpalette.base
            enabled: chargingProfile !== null
            opacity: chargingProfile !== null ? 1.0 : 0.5

            DateTimeAxis {
                id: axisX
                min: new Date(startTime * 1000)
                max: new Date(endTime * 1000)
                format: "HH:mm"
                tickCount: 7
                labelsFont.pixelSize: lkfont.sizeSmall
                titleFont.pixelSize: lkfont.sizeSmall
                labelsColor: lkpalette.base_white
                gridLineColor: lkpalette.base_white
                lineVisible: true
                gridVisible: true
                color: lkpalette.base_white
            }

            ValueAxis {
                id: axisY
                min: 0
                max: 20
                titleText: qsTr("Current") + " (A)"
                labelFormat: "%.0f"
                tickCount: 7
                labelsFont.pixelSize: lkfont.sizeMediumSmall
                titleFont.pixelSize: lkfont.sizeMediumSmall
                labelsColor: lkpalette.base_white
                gridLineColor: lkpalette.base_white
                lineVisible: true
                gridVisible: true
                color: lkpalette.base_white
                titleVisible: true
                titleBrush: lkpalette.base_white
            }

            LineSeries {
                id: chargingSeries
                axisX: axisX
                axisY: axisY
                width: 4 * scaleFactor
                color: lkpalette.signalgreen
            }

            ScatterSeries {
                id: highlightSeries
                axisX: axisX
                axisY: axisY
                color: "white"
                markerSize: 12
                visible: highlightedPointIndex >= 0
            }

            // Mouse area for scrolling and point interaction
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                enabled: chargingProfile !== null

                property point lastPoint
                property bool isDragging: false

                function findNearestPoint(mouseX, mouseY) {
                    if (!chargingProfile || dataPoints.length === 0) return -1

                    let chartPos = chartView.mapToValue(Qt.point(mouseX, mouseY), chargingSeries)
                    let minDistance = Number.MAX_VALUE
                    let nearestIndex = -1

                    // Convert mouse position to chart coordinates
                    const clickX = chartPos.x
                    const clickY = chartPos.y

                    // Check each line segment
                    for (let i = 0; i < dataPoints.length - 1; i++) {
                        let p1 = dataPoints[i]
                        let p2 = dataPoints[i + 1]

                        let x1 = p1.time * 1000
                        let y1 = p1.current
                        let x2 = p2.time * 1000
                        let y2 = p2.current

                        // If click is near this segment's time range (be more forgiving)
                        if (clickX >= (x1 - 3600000) && clickX <= (x2 + 3600000)) {
                            // Get y-value on the line at click x-position
                            let ratio = (clickX - x1) / (x2 - x1)
                            let lineY = y1 + (ratio * (y2 - y1))

                            // Calculate vertical distance to the line
                            let distance = Math.abs(clickY - lineY)

                            if (distance < minDistance) {
                                minDistance = distance
                                // If closer to p2, select p2, otherwise select p1
                                nearestIndex = (clickX - x1) > (x2 - clickX) ? i + 1 : i
                            }
                        }
                    }

                    // Special handling for the last segment (extending to endTime)
                    if (dataPoints.length > 0) {
                        let lastPoint = dataPoints[dataPoints.length - 1]
                        let x1 = lastPoint.time * 1000
                        let y1 = lastPoint.current
                        let x2 = endTime * 1000

                        // If click is after the last transition point
                        if (clickX >= x1) {
                            // For the final segment, vertical distance to the last known current value
                            let distance = Math.abs(clickY - y1)
                            if (distance < minDistance) {
                                minDistance = distance
                                nearestIndex = dataPoints.length - 1
                            }
                        }
                    }

                    // Be very forgiving with the vertical distance threshold
                    return minDistance < 10 ? nearestIndex : -1
                }

                onPositionChanged: (mouse) => {
                    if (!isDragging && !pointSelected) {
                        highlightedPointIndex = findNearestPoint(mouse.x, mouse.y)

                        if (highlightedPointIndex >= 0) {
                            highlightSeries.clear()
                            highlightSeries.append(
                                dataPoints[highlightedPointIndex].time * 1000,
                                dataPoints[highlightedPointIndex].current
                            )
                        }
                    } else if (isDragging) {
                        let dx = (mouse.x - lastPoint.x) / width
                        let timeRange = axisX.max.getTime() - axisX.min.getTime()
                        let deltaX = dx * timeRange

                        const newMin = axisX.min.getTime() - deltaX
                        const newMax = axisX.max.getTime() - deltaX

                        if (newMin >= startTime * 1000 && newMax <= endTime * 1000) {
                            axisX.min = new Date(newMin)
                            axisX.max = new Date(newMax)
                        }

                        lastPoint = Qt.point(mouse.x, mouse.y)
                    }
                }

                property bool pointSelected: false

                onPressed: (mouse) => {
                    pointSelected = false
                    // First check if we're clicking near a point
                    let nearestPoint = findNearestPoint(mouse.x, mouse.y)
                    if (nearestPoint >= 0) {
                        highlightedPointIndex = nearestPoint
                        highlightSeries.clear()
                        highlightSeries.append(
                            dataPoints[nearestPoint].time * 1000,
                            dataPoints[nearestPoint].current
                        )
                        pointSelected = true
                    } else {
                        // If not near a point, start dragging
                        isDragging = true
                        lastPoint = Qt.point(mouse.x, mouse.y)
                        cursorShape = Qt.ClosedHandCursor
                    }
                }

                onReleased: {
                    if (!pointSelected) {
                        isDragging = false
                        cursorShape = Qt.ArrowCursor
                        if (!containsMouse) {
                            highlightedPointIndex = -1
                            highlightSeries.clear()
                        }
                    }
                }

                onExited: {
                    if (!pointSelected) {
                        highlightedPointIndex = -1
                        highlightSeries.clear()
                    }
                }

                onClicked: (mouse) => {
                    if (!pointSelected) {
                        highlightedPointIndex = -1
                        highlightSeries.clear()
                    }
                }
            }
        }
    }

    function update_chargingprofile(ok, config) {
        if(ok) {
            chargingProfile = config['cs_charging_profiles'];
        }
    }

    Component.onCompleted: {
        lkinterface.charger.get_charger_smart_schedule(stationid, update_chargingprofile)
    }
}
