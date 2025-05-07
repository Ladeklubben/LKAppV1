import QtQuick 2.13

Item{
    signal done();
    property bool tax_reduction_on: false;
    property bool tax_reduction_by_ladeklubben: false;

    Column{
        width: parent.width;
        spacing: 10;
        anchors.margins: 5;
        LKToggleSetting{
            id: tax_reduction_on_off_picker;
            text: qsTr("Reduced electricity tax") + "?:";
            helper: qsTr("Chose whether you are obliged to have you electricity tax reduced.")
            activated: 0;
            onActivatedChanged: {
                tax_reduction_on = activated == 1;
            }
        }
        LKToggleSetting{
            text: qsTr("Handled by Ladeklubben") + "?:";
            helper: qsTr("Choose this if Ladeklubben should handle having your electricity tax reduced.")
            activated: 0;
            enabled: tax_reduction_on_off_picker.activated;
            onActivatedChanged: {
                if(enabled){
                    tax_reduction_by_ladeklubben = activated == 1;
                }
                else{
                    tax_reduction_by_ladeklubben = false;
                }
            }
        }
    }

    LKButtonRowNextHelp{
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;

        function next_page(){
            done();
        }
        next: next_page;
        help: qsTr(
                  "Setup how you electricity price will be calculated. If you have reduced electricity tax the final cost of electricity will be without tax." +
                  "");
    }
}

