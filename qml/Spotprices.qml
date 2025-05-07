import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    /* Make these properties as arguments to the class */
    property string headertext: qsTr("ELECTRICITY PRICES")

    property real low;
    property real mid;
    function calc_color(value){
        if(value <= low){
            return "#D1E7DD";
        }
        if(value <= mid){
            return "#ECE1BE"
        }
        return "#F8D7DA"
    }
    id: sp_root;
    anchors.fill: parent;

    LKScrollPage{
        id: scroll_page
        height: parent.height;
        width: parent.width;
        refreshEnable: true;
        onUpdateView:{
            sp.update_prices();
        }

        content:ListView {
            id: sp;

            ListModel{
                id: spotprices;
            }

            implicitHeight: contentHeight;
            width: parent ? parent.width - 10 : 0;
            anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined;
            interactive: false;

            clip: true;
            spacing: 1;
            model: spotprices;

            header: Row{
                width: parent.width;
                Layout.fillWidth: true;
                Label{
                    width: parent.width / 2;
                    horizontalAlignment: Qt.AlignLeft;
                    text: qsTr("Time");
                    color: "white";
                }
                Label{
                    width: parent.width / 4;
                    Layout.fillWidth: true;
                    horizontalAlignment: Qt.AlignLeft;
                    text: qsTr("Cost excl tax");
                    color: "white";
                }
                Label{
                    width: parent.width / 4;
                    horizontalAlignment: Qt.AlignCenter;
                    Layout.alignment: Qt.AlignRight;
                    text: qsTr("Cost incl tax");
                    color: "white";

                }
            }

            delegate: SpotpriceItem{
                width: sp.width;
                color: calc_color(Costprice);
                Layout.fillWidth: true;
            }

            function update_prices(){
                spotprices.clear();
                http.request('/electricity/cost', '', function (o) {
                    if(o.readyState === XMLHttpRequest.DONE){
                        if(o.status === 200) {
                            var p = JSON.parse(o.responseText);
                            let maximum = parseFloat(p.maximum['Costprice'])/100;
                            let minimum = parseFloat(p.minimum['Costprice'])/100;

                            let step = (maximum - minimum)/5;
                            low = step * 1 + minimum;
                            mid = step * 2 + minimum;

                            for(var i=0; i< p.price_list.length; i++){
                                var priceinf = p.price_list[i];
                                var t = new Date(priceinf.Timestamp*1000);
                                spotprices.append({
                                    'Timestamp': t.getDate() + "." + (parseInt(t.getMonth())+1) + "." + t.getFullYear() + " " + t.getHours() + ".00",
                                    'Spotprice': ((priceinf.Spotprice)/100).toFixed(2),
                                    'Costprice_VAT': ((priceinf.Costprice_VAT)/100).toFixed(2),
                                    'Costprice': ((priceinf.Costprice)/100).toFixed(2),
                                    'Subscribtion_price': priceinf.Subscribtion_price,
                                    'SpotpriceSupplement': priceinf.SpotpriceSupplement !== undefined ? priceinf.SpotpriceSupplement : 0,
                                    'Energynet_tariff': priceinf.Energynet_tariff,
                                    'Distribution_tariff': priceinf.Distribution_tariff,
                                    'EnergyTax_tariff': priceinf.EnergyTax_tariff,
                                    'Spotprice_tariff': ((priceinf.Spotprice_tariff)/100).toFixed(2),
                                })
                            }
                        }
                        else if(o.status === 0) {

                        }
                        else{
                            console.log("ERROR", o.status);
                        }
                    }
                });
            }

            Component.onCompleted: {
                update_prices();
            }
        }
    }
}
