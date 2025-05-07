import QtQuick
import QtCharts

Item {
    property int tid;

    function generate_plot_axis(times, energy){
        valueAxis.min = new Date(times[0]*1000);
        valueAxis.max = new Date(times[times.length - 1]*1000);

        let ymax = 0;
        let ymin = -0.1;
        for(var i=0; i<times.length; i++){
            plotpoints.append(times[i]*1000, energy[i]);
            if(energy[i] > ymax) ymax = energy[i];
            if(energy[i] < ymin) ymin = energy[i];
        }
        yAxis.min = ymin;
        yAxis.max = parseInt(ymax) + 1;
    }

    function req_transaction_data(tid){
        http.request("/ta/" + stationid + "/plot?tid=" + tid, '', function (o) {
            if(o.readyState === XMLHttpRequest.DONE){
                if(o.status === 200) {
                    var js = JSON.parse(o.responseText);
                    generate_plot_axis(js['timestamps'], js['values']);
                }
                else if(o.status === 0) {
                    //message = "Network error";
                    console.log(o.status)
                }
                else{

                }
            }
        });
    }

    ChartView {
        title: qsTr("Transaction") + " " + tid;
        anchors.fill: parent
        antialiasing: true;
        backgroundColor: lkpalette.base;
        animationOptions: ChartView.SeriesAnimations  //Disabled on android - its too slows
        backgroundRoundness: 0;
        dropShadowEnabled: false;
        titleColor: lkpalette.base_white;
        legend.visible: false

        DateTimeAxis {
            id: valueAxis
            format: "hh:mm"
            tickCount: 5
            labelsColor: lkpalette.base_white;
        }

        ValueAxis {
            id: yAxis
            min: 0
            max: 15
            tickAnchor: 1;
            tickInterval: 1;
            tickType: ValueAxis.TicksDynamic;
            color: lkpalette.base_white;
            labelsColor: lkpalette.base_white;
            gridLineColor: lkpalette.base_white;
        }

        // Define x-axis to be used with the series instead of default one
        LineSeries {
            id: plotpoints;
            axisX: valueAxis
            axisY: yAxis;
            color: lkpalette.signalgreen;
            width: 2;
        }
    }

    Component.onCompleted: {
        req_transaction_data(tid);
    }
}
