import QtQuick
import QtCharts;

ChartView {
    id: chart

    signal dig_deeper(var index, var value);

    legend.visible: false

    antialiasing: true;
    backgroundColor: lkpalette.base;
    animationOptions: ChartView.SeriesAnimations  //Disabled on android - its too slow
    backgroundRoundness: 0;
    dropShadowEnabled: false;
    titleColor: lkpalette.base_white;

    function barclicked(index, barset){
        var consumptionseries = series(0);
        var myAxisX = chart.axisX(consumptionseries);
        // cb(myAxisX.categories[index], index);
        // cb(index, barset)
        dig_deeper(index, myAxisX.categories[index])

    }

    function update_plot(callback, label, plotdata, x_labels=null){
        chart.title = label;
        removeAllSeries();
        var consumptionseries = createSeries(ChartView.SeriesTypeBar);
        consumptionseries.useOpenGL = true;

        var myAxisX = axisX(consumptionseries);
        var myAxisY = axisY(consumptionseries);

        let m = 0;
        var y = new Array(Object.entries(plotdata).length);
        var x = new Array(Object.entries(plotdata).length);
        let i=0;
        for(const [key, value] of Object.entries(plotdata)){
            y[i] = value;
            x[i] = key;
            if(x_labels !== null){
                x[i] = x_labels[i].slice(0,3);
            }
            i++;

            if(value > m) m = value;
        }

        var mBarSet = consumptionseries.append("Consumption", y)
        mBarSet.clicked.connect(barclicked);
        mBarSet.color = lkpalette.signalgreen;
        mBarSet.borderColor = lkpalette.base_grey;
        mBarSet.label = label;

        myAxisX.categories = x;
        myAxisX.labelsAngle = x_labels !== null ? 30 : 0;
        myAxisX.labelsFont.pointSize = lkfont.sizeSmall;
        myAxisX.truncateLabels = false;
        setAxisX(myAxisX, consumptionseries);
        setAxisY(myAxisY, consumptionseries);

        myAxisY.max = m;
        myAxisY.min = 0.0;
    }

    BarSeries{
        axisX: BarCategoryAxis {    //X-axis
            labelsColor: lkpalette.base_white;
            gridVisible: false;
        }
        axisY: ValueAxis {      //Y-axis
            min: 0.0;
            color: lkpalette.base_white;
            labelsColor: lkpalette.base_white;
            gridLineColor: lkpalette.base_white;
        }
    }
}

