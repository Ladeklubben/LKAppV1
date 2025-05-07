import QtQuick
import QtQuick.Window
import QtQuick.Controls
import Qt.labs.settings
import QtQuick.Layouts

Item {
    // Store the initial numeric values
    property double _nom_price_value: stationdata.listprice.nominal * 1.25
    property double _min_price_value: stationdata.listprice.minimum * 1.25
    property double _fallback_price_value: stationdata.listprice.fallback * 1.25
    property string valuta: stationdata.listprice.valuta
    property int follow_spot: stationdata.listprice.follow_spot

    function updateListprice(nomprice, minprice, fallbackprice, follow) {
        // Convert string prices to numbers for the API
        var nomValue = Number.fromLocaleString(Qt.locale(), nomprice) * 0.8
        var minValue = Number.fromLocaleString(Qt.locale(), minprice) * 0.8
        var fallbackValue = Number.fromLocaleString(Qt.locale(), fallbackprice) * 0.8

        var payload = JSON.stringify({
                                         'nominal': nomValue,
                                         'minimum': minValue,
                                         'fallback': fallbackValue,
                                         'valuta': 'DKK',
                                         'follow_spot': follow,
                                     })

        http.put('/listprice/' + stationid, payload, function (o) {
            if(o.readyState === XMLHttpRequest.DONE) {
                if(o.status === 200) {
                    stationdata.listprice.nominal = nomValue
                    stationdata.listprice.minimum = minValue
                    stationdata.listprice.follow_spot = follow
                    stationdata.listprice.fallback = fallbackValue

                    // Update our local values
                    _nom_price_value = nomValue * 1.25
                    _min_price_value = minValue * 1.25
                    _fallback_price_value = fallbackValue * 1.25
                }
                else if(o.status === 0) {
                    // Handle error
                }
                else if(o.status === 429) {
                    var js = JSON.parse(o.responseText)
                    console.log("Too many request, ready in", js.seconds_remaining)
                }
                else {
                    console.log("ERROR", o.status)
                }
            }
        })
    }
    ColumnLayout {
        spacing: 15
        Layout.fillHeight: false
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5

        LKToggleSetting {
            id: followcheck
            activated: follow_spot == 1
            text: qsTr("Follow the energy price") + "?"
            helper: qsTr("If checked, charger prices will follow actual energy prices which will change during the day. If unchecked the price will be the same no matter the time of day.")
        }

        LKPriceEdit {
            id: pe_nomprice
            headline: (followcheck.activated ? qsTr("Unit price offset") : qsTr("Unit price")) + ":"
            helpertext: followcheck.activated ? qsTr("This is the offset that will be put ontop of the actual energy price.") :
                                                qsTr("This is the fixed amount that will be charged for each kWh consumed.")
            Component.onCompleted: {
                // Set initial value using the text-based approach
                setFromNumericValue(_nom_price_value)
            }
            minimum: pe_minprice.getPrice()

            KeyNavigation.down: pe_minprice
            KeyNavigation.tab: pe_minprice
        }

        LKPriceEdit {
            id: pe_minprice
            headline: qsTr("Minumum price") + ":"
            helpertext: qsTr("A possible discount price cannot go below below this value")
            Component.onCompleted: {
                // Set initial value using the text-based approach
                setFromNumericValue(_min_price_value)
            }

            KeyNavigation.up: pe_nomprice
            KeyNavigation.tab: pe_fallbackprice
        }

        LKPriceEdit {
            id: pe_fallbackprice
            headline: qsTr("Fallback price") + ":"
            helpertext: qsTr("If public spot prices are not updated, we will use this as a default fallback price. This will prevent loss in cases where systems we rely on, are malfunctioning")
            Component.onCompleted: {
                // Set initial value using the text-based approach
                setFromNumericValue(_fallback_price_value)
            }

            KeyNavigation.up: pe_minprice
            KeyNavigation.tab: pe_nomprice

            visible: followcheck.activated
        }
    }

    LKButtonRowSubmitHelp {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        enable_submit: pe_nomprice.accepted && pe_minprice.accepted && pe_fallbackprice.accepted && (pe_nomprice.changed || pe_minprice.changed || followcheck.changed || pe_fallbackprice.changed)
        help: qsTr("On this page you control the list price of the charging stand and will be what will be shown to your paying customers. This will be the price listet before any discounts set on a group.")
        submit: function() {
            pe_nomprice.changed = false
            pe_minprice.changed = false
            followcheck.changed = false
            pe_fallbackprice.changed = false
            updateListprice(pe_nomprice.priceText, pe_minprice.priceText, pe_fallbackprice.priceText, followcheck.activated)
        }
    }

    Component.onCompleted: {
        header.headText = qsTr("STANDARD PRICE SETUP")
        console.log("min_price", _min_price_value)
    }
}
