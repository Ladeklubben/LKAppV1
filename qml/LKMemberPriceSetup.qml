import QtQuick 2.13

/*
This Item will be generated for all special cases that the member is included in.
When another member hand out an invite, for a special price on his charger, this
is where it is set.
In the end, this item will determine what the sellig price will be
*/

Item {
    property string stationid;
    property real tariff_pct: 0;    //Default, no discount. 100 is all discount
    property real discount_tariff: 0;
    property bool flat: false;
    property bool free: false;

    onDiscount_tariffChanged: {
        if(!(flat || free)) tariff_pct = discount_tariff;
    }
}
