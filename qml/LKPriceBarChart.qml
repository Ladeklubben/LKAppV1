import QtQuick
import QtCharts

Item{
    property var listofprices;
    property var epoch_start;
    property int max_hours_ahead: 12;
    property alias title: chart.title;

    anchors.fill: parent;

    ChartView {
        id: chart

        width: parent.width * 0.9;
        height: parent.height * 0.5;
        anchors.centerIn: parent;

        legend.visible: false

        antialiasing: true
        backgroundColor: lkpalette.base;
        animationOptions: ChartView.SeriesAnimations  //Disabled on android - its too slows
        backgroundRoundness: 0;
        dropShadowEnabled: false;
        titleColor: lkpalette.base_white;

        property list<string> xaxis_labels;

        BarSeries {
            id: prices;
            axisX: BarCategoryAxis {
                id: valueAxis
                labelsColor: lkpalette.base_white;
                gridVisible: false;
            }
            axisY: ValueAxis {
                id: yaxis;
                max: 250.0;
                min: 0.0;
                color: lkpalette.base_white;
                labelsColor: lkpalette.base_white;
                gridLineColor: lkpalette.base_white;
            }

            BarSet{
                label: qsTr("Cost")
                values: listofprices;
                color: lkpalette.signalgreen;
                borderColor: lkpalette.base_grey;
            }
            barWidth: 0.8
        }

        Component.onCompleted: {
            var t = new Date(epoch_start*1000);
            var hour = t.getHours();
            var ymax = 0;
            var ymin = 0;

            for(var i=0; i<listofprices.length; i++){
                xaxis_labels.push(hour);
                hour += 1;
                if(hour > 23){
                    hour = 0;
                }

                ymax = listofprices[i] > ymax ? listofprices[i] : ymax;
                ymin = listofprices[i] < ymin ? listofprices[i] : ymin;
                if(i >= max_hours_ahead-1) break;
            }
            valueAxis.categories = xaxis_labels;
            ymax = parseInt(ymax + 0.75) + 0.5;
            yaxis.max = ymax;
            yaxis.min = ymin * 1.25;
        }
    }
}
