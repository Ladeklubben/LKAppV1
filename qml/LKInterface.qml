import QtQuick

QtObject {
    property var user: LKUserInterface{};
    property var admin: LKAdminInterface{};
    property var charger: LKChargerInterface{};
    property var ocpp: LKOCPPInterface{};
    property var guestcharge: LKGuestChargeInterface{};
    property var electricitySettlement: LKElectrictyInterface2{};
    property var schedule_opening: LKScheduleInterface{geturi: '/openhours'; edituri: '/openhours';}
    property var schedule_alwayson: LKScheduleInterface{geturi: '/alwayson'; edituri: '/alwayson'; }
    property var order: LKOrderInterface{};
    property var installation: LKInstallationInterface{};
}
