import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQml 2.12
import QtQuick.Layouts 1.12
import QtQuick 2.12

ScrollView {
    /* Make these properties as arguments to the class */
    property var user: userinfo
    property string headertext: qsTr("MENU")
    property string headersubtext: "";
    property int menuItemHeight: 85
    property int margin: 20

    signal itemClicked(var item)
    function showPage(page) {
        itemClicked(page);
        activestack.push(page);
    }

    ScrollBar.vertical: LKScrollBar{
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }

    ColumnLayout {
        spacing: 20
        anchors.fill: parent
        anchors.margins: margin


        Rectangle {
            Layout.fillWidth: true
            color: lkpalette.base_extra_dark
            enabled: member_role !== "Non-Member" && loggedin;
            visible: member_role !== "Non-Member" && loggedin;
            radius: 20


            GridLayout {
                id: gridLayout
                columns: 2
                columnSpacing: 20
                rowSpacing: 10
                anchors.fill: parent
                anchors.margins: margin

                // Company name or regular name
                Label {
                    text: user !== undefined && user.companyName ? qsTr("Company") + ":" : qsTr("Name") + ":"
                    color: "White"
                    font.bold: true
                    font.pointSize: lkfont.sizeMediumSmall
                }
                Label {
                    text: user === undefined ? "" : (user.companyName ? user.companyName : user.name)
                    color: "White"
                    font.pointSize: lkfont.sizeMediumSmall
                }

                // Attention field - only visible when company name exists
                Label {
                    text: qsTr("Att") + ":"
                    color: "White"
                    font.bold: true
                    font.pointSize: lkfont.sizeMediumSmall
                    visible: user !== undefined && user.companyName && user.companyName.trim() !== ""
                }
                Label {
                    text: user === undefined ? "" : user.name
                    color: "White"
                    font.pointSize: lkfont.sizeMediumSmall
                    visible: user !== undefined && user.companyName && user.companyName.trim() !== ""
                }

                // Rest of the fields remain the same
                Label {
                    text: qsTr("Email") + ":"
                    color: "White"
                    font.bold: true
                    font.pointSize: lkfont.sizeMediumSmall
                }
                Label {
                    text: user === undefined ? "" : user.email
                    color: "White"
                    font.pointSize: lkfont.sizeMediumSmall
                }
                Label {
                    text: qsTr("Street") + ":"
                    color: "White"
                    font.bold: true
                    font.pointSize: lkfont.sizeMediumSmall
                }
                Label {
                    text: user === undefined ? "" : user.street
                    color: "White"
                    font.pointSize: lkfont.sizeMediumSmall
                }
                Label {
                    text: qsTr("Zip") + ":"
                    color: "White"
                    font.bold: true
                    font.pointSize: lkfont.sizeMediumSmall
                }
                Label {
                    text: user === undefined ? "" : user.zip
                    color: "White"
                    font.pointSize: lkfont.sizeMediumSmall
                }
                Label {
                    text: qsTr("City") + ":"
                    color: "White"
                    font.bold: true
                    font.pointSize: lkfont.sizeMediumSmall
                }
                Label {
                    text: user === undefined ? "" : user.city
                    color: "White"
                    font.pointSize: lkfont.sizeMediumSmall
                }
            }
            height: gridLayout.implicitHeight + 2 * margin

            LKIconButton {
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    margins: 20
                }
                text: "\uE800"
                onClicked: {
                    activestack.push(editUser)
                }
                height: 20
                width: 20
            }
        }

        /*********************/



        LKMenuItem {
            height: menuItemHeight
            Layout.fillWidth: true
            icon: "\uE819"
            text: qsTr("Groups")
            description: qsTr("Give special offers to people")
            onClicked: {
                activestack.push(groupconfig);
            }
            with_seperator: false
            icon_color: lkpalette.menuItemIcon2
            icon_bk_color: lkpalette.menuItemBackground2
            visible: member_role !== "Non-Member" && loggedin;
        }

        LKMenuItem {
            height: menuItemHeight
            Layout.fillWidth: true
            icon: "\uE819"
            text: qsTr("Group invites")
            description: qsTr("View your group invites")
            visible: guestgroups.guest_pending_invites.count > 0
            onClicked: {
                activestack.push(group_invites);
            }
            with_seperator: false
            icon_color: lkpalette.menuItemIcon2
            icon_bk_color: lkpalette.menuItemBackground2
        }

        // LKMenuItem {
        //     height: menuItemHeight
        //     Layout.fillWidth: true
        //     icon: "\uE80F"
        //     text: qsTr("Balance")
        //     description: qsTr("View your balance sheet")
        //     onClicked: {
        //         activestack.push(balancesheetview);
        //     }
        //     icon_color: lkpalette.menuItemIcon3
        //     icon_bk_color: lkpalette.menuItemBackground3
        //     visible: loggedin
        // }

        LKMenuItem {
            height: menuItemHeight
            Layout.fillWidth: true
            icon: "\uE80E"
            text: qsTr("Purchaces")
            description: qsTr("View your previous purchaces")
            onClicked: {
                activestack.push(purchaces_view);
            }
            icon_color: lkpalette.menuItemIcon4
            icon_bk_color: lkpalette.menuItemBackground4
            visible: loggedin
        }

        LKMenuItem {
            height: menuItemHeight
            Layout.fillWidth: true
            icon: "\uF1E6"
            text: qsTr("Sales")
            description: qsTr("View your previous sales")
            onClicked: {
                activestack.push(sales_view);
            }
            icon_color: lkpalette.menuItemIcon5
            icon_bk_color: lkpalette.menuItemBackground5
            visible: loggedin
        }

        LKMenuItem {
            height: menuItemHeight
            Layout.fillWidth: true
            icon: "\uE80D"
            text: qsTr("Payment cards")
            description: qsTr("Edit your payment methods")
            onClicked: {
                activestack.push(paymentcardsview);
            }
            icon_color: lkpalette.menuItemIcon6
            icon_bk_color: lkpalette.menuItemBackground6
            visible: loggedin
        }

        LKMenuItem {
            height: menuItemHeight
            Layout.fillWidth: true
            icon: "\uE81F"
            text: qsTr("Add charger")
            description: qsTr("Add a new charger to your profile")
            onClicked: {
                activestack.push(newchargerview);
            }
            icon_color: lkpalette.menuItemIcon7
            icon_bk_color: lkpalette.menuItemBackground7
            visible: member_role !== "Non-Member" && loggedin
        }

        LKMenuItem{
            height: menuItemHeight
            Layout.fillWidth: true
            icon: "\uE81F"
            text: qsTr("Installation")
            description: qsTr("Define your installations")
            onClicked: {
                activestack.push(installation);
            }
            icon_color: lkpalette.menuItemIcon3
            icon_bk_color: lkpalette.menuItemBackground3
            enabled: member_role === "SuperAdmin" && loggedin
            visible: member_role === "SuperAdmin" && loggedin
        }

        LKMenuItem {
            height: menuItemHeight
            Layout.fillWidth: true
            icon: "\uE820"
            text: qsTr("About us")
            description: qsTr("Info about company and app")
            onClicked: {
                activestack.push(aboutUs);
            }
            with_seperator: false
            icon_color: lkpalette.menuItemIcon2
            icon_bk_color: lkpalette.menuItemBackground2
            visible: loggedin
        }

        LKMenuItem {
            height: menuItemHeight
            Layout.fillWidth: true
            icon: "\uE844"
            text: qsTr("Admin")
            description: qsTr("Tools for the admin users")
            onClicked: {
                showPage(adminpage);
            }
            icon_color: lkpalette.menuItemIcon1
            icon_bk_color: lkpalette.menuItemBackground1
            enabled: member_role === "SuperAdmin" && loggedin
            visible: member_role === "SuperAdmin" && loggedin
        }

        LKMenuItem {
            height: menuItemHeight
            Layout.fillWidth: true
            icon: "\uE804"
            text: loggedin ? qsTr("Log out") : qsTr("Log in")
            description: loggedin ? qsTr("Log out of Ladeklubben") : qsTr("Log in to Ladeklubben")
            icon_color: lkpalette.menuItemIcon5
            icon_bk_color: lkpalette.menuItemBackground5
            onClicked: {
                stations = undefined;
                selectedPage = "map";
                activestack.clear();
                activestack = rootstack;
                rootstack.clear();
                credentials.password = "";
                credentials.token = "";
                showPage(loginstack);
            }
        }

        LKMenuItem {
            height: menuItemHeight
            Layout.fillWidth: true
            icon: "\uE80B"
            color: lkpalette.menuWarningBackground
            text: qsTr("Stop membership")
            description: qsTr("Close your Ladeklubben account")
            onClicked: {
                alertbox.setSource("LKMemberStopWarning.qml");
            }
            icon_color: lkpalette.menuItemIcon6
            icon_bk_color: lkpalette.menuItemBackground6
            visible: loggedin
        }

        Component {
            id: groupconfig
            GroupsView {
                property string headertext: qsTr("GROUPS")
            }
        }

        Component {
            id: editUser
            EditUser{

            }
        }

        Component{
            id: newchargerview
            NewChargerView{
                property string headertext: qsTr("ADD CHARGER")
            }
        }

        Component {
            id: aboutUs
            AboutUs{

            }
        }

        Component {
            id: accountpage
            AccountPage {
            }
        }

        Component {
            id: paymentcardsview
            PaymentCardsView {
                property string headertext: qsTr("PAYMENT CARDS")
            }
        }

        Component {
            id: balancesheetview
            BalanceSheetView {
                property string headertext: qsTr("BALANCE")
            }
        }

        Component {
            id: purchaces_view
            PuchasesView {
                property string headertext: qsTr("PURCHASES")
            }
        }

        Component {
            id: sales_view
            SalesView {
                property string headertext: qsTr("SALES")
            }
        }

        Component{
            id: installation;
            Mainmeter{
                property string headertext: qsTr("INSTALLATION")
            }
        }

        // Bottom Padding
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: margin
        }
    }
}
