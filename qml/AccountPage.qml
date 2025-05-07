import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12

Item{
    id: accountpage_content;
    property string headertext: qsTr("ACCOUNT");
    property int menuItemHeight: 85;
    Item{

        anchors.margins: 5;
        anchors.left: parent.left;
        anchors.right: parent.right;

        Column{
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.top: parent.top;
            anchors.margins: 20;
            spacing: 20;
            
            LKMenuItem{
                height: menuItemHeight;
                width: parent.width;
                anchors.left: parent.left;
                icon: "\uE80F";
                text: qsTr("Balance");
                description: qsTr("View your balance sheet");
                onClicked: activestack.push(balancesheetview);
                icon_color: lkpalette.menuItemIcon1
                icon_bk_color: lkpalette.menuItemBackground1
            }
            LKMenuItem{
                height: menuItemHeight;
                width: parent.width;
                anchors.left: parent.left;
                icon: "\uE80E";
                text: qsTr("Purchaces");
                description: qsTr("View your previous purchaces");
                onClicked: activestack.push(purchaces_view);
                icon_color: lkpalette.menuItemIcon2
                icon_bk_color: lkpalette.menuItemBackground2
            }
            LKMenuItem{
                height: menuItemHeight;
                width: parent.width;
                anchors.left: parent.left;
                icon: "\uF1E6";
                text: qsTr("Sales");
                description: qsTr("View your previous sales");
                onClicked: activestack.push(sales_view);
                icon_color: lkpalette.menuItemIcon3
                icon_bk_color: lkpalette.menuItemBackground3
            }
            LKMenuItem{
                height: menuItemHeight;
                width: parent.width;
                anchors.left: parent.left;
                icon: "\uE80D";
                text: qsTr("Payment cards");
                description: qsTr("View and edit your payment methods");
                onClicked: activestack.push(paymentcardsview);
                icon_color: lkpalette.menuItemIcon4
                icon_bk_color: lkpalette.menuItemBackground4
            }
        }
    }

    Component{
        id: paymentcardsview;
        PaymentCardsView{
            property string headertext: qsTr("PAYMENT CARDS")
        }
    }

    Component{
        id: balancesheetview;
        BalanceSheetView{
            property string headertext: qsTr("BALANCE")
        }
    }

    Component{
        id: purchaces_view;
        PuchasesView
        {
            property string headertext: qsTr("PURCHASES")
        }
    }

    Component{
        id: sales_view;
        SalesView{
            property string headertext: qsTr("SALES")
        }
    }

}
