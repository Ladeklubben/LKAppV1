import QtLocation
import QtPositioning
import QtQuick
import QtQuick.Controls
import QtCore

Map {
    id: map

    property geoCoordinate startCentroid
    property bool follow_position: true

    plugin: Plugin {
        name: "osm"
        PluginParameter {
            name: "osm.mapping.custom.host"
            value: "https://a.tile.openstreetmap.org/"
        }
    }
    activeMapType: supportedMapTypes[supportedMapTypes.length - 1]
    zoomLevel: 13
    maximumZoomLevel: 18
    center: QtPositioning.coordinate(54.913682, 9.490540);

    onZoomLevelChanged: {
        updatetimer.restart();
    }

    Timer {
        id: updatetimer
        interval: 500
        onTriggered: {
            map.zoomLevel = map.zoomLevel.toFixed(0);
        }
    }

    DragHandler {
        id: drag
        target: null
        onTranslationChanged: function(delta){
            map.pan(-delta.x, -delta.y)
            follow_position = false;
        }

        //snapMode: DragHandler.SnapNever
    }

    PinchHandler {
        id: pinch
        target: null
        onActiveChanged: if (active) {
                             map.startCentroid = map.toCoordinate(pinch.centroid.position, false);
                         }
        onScaleChanged: delta => {
                            map.zoomLevel += Math.log2(delta);
                            map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position);
                        }
        onRotationChanged: delta => {
                               var rotationThreshold = 0.3;
                               if (Math.abs(delta) > rotationThreshold) {
                                   map.bearing -= delta * 0.5;
                                   map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position);
                               }
                           }
    }

    WheelHandler {
        id: wheel
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        target: null
        rotationScale: 1 / 120

        property real lastZoomTime: 0
        property real zoomFactor: 0.2  // Base zoom factor

        onWheel: function(event) {
            // Calculate time since last zoom
            var currentTime = Date.now();
            var timeDelta = currentTime - lastZoomTime;

            // Reduce sensitivity for rapid scrolling
            var adjustedZoomFactor = timeDelta < 100 ? zoomFactor * 0.5 : zoomFactor;

            if (event.angleDelta.y > 0)
                map.zoomLevel += adjustedZoomFactor;
            else
                map.zoomLevel -= adjustedZoomFactor;

            lastZoomTime = currentTime;
            event.accepted = true;
        }
    }
}
