QT += core quick svg webview location core5compat

CONFIG += c++11
CONFIG += qzxing_multimedia
CONFIG += qzxing_qml

include(QZXing/QZXing.pri)


# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

TARGET = "Ladeklubben"

# The application version
VERSION = 0.0.23

# Define the preprocessor macro to get the application version in our application.
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        pushnotification.cpp

HEADERS += \
        pushnotification.h

RESOURCES += qml.qrc \
    $$PWD/Account.qrc \
    $$PWD/ChargerSetup.qrc \
    $$PWD/Password.qrc \
    $$PWD/data.qrc \
    $$PWD/electricity.qrc \
    $$PWD/fonts.qrc \
    PaymentWidgets.qrc \
    Viewpages.qrc \
    chargerwidgets.qrc \
    groupwidgets.qrc \
    guestwidgets.qrc \
    icons.qrc \
    mapwidget.qrc \
    schedulewidgets.qrc \
    scripts.qrc \
    statwidgets.qrc \
    translations.qrc \
    widgets.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

win32 {
    !contains(QMAKE_TARGET.arch, x86_64) {
        message("x86 build")
    } else {
        message("x86_64 build")
        CONFIG(release, debug|release): DESTDIR = $$OUT_PWD/release
        CONFIG(debug, debug|release): DESTDIR = $$OUT_PWD/debug
        copydata.commands = $(COPY_DIR) $$shell_quote($$shell_path($$PWD/windows_openssl)) $$shell_quote($$shell_path($$DESTDIR))
        first.depends = $(first) copydata
        export(first.depends)
        export(copydata.commands)
        QMAKE_EXTRA_TARGETS += first copydata

    }
}

ios {
    QMAKE_INFO_PLIST = ios/Info.plist
    QMAKE_TARGET_BUNDLE_PREFIX = dk.ladeklubben
    QMAKE_BUNDLE = app
    QMAKE_ASSET_CATALOGS = $$PWD/ios/Assets.xcassets
    QMAKE_ASSET_CATALOGS_APP_ICON = "AppIcon"

    # Set "Target"
    QMAKE_IOS_DEPLOYMENT_TARGET = 12.0

    # Set "Devices" (1=iPhone, 2=iPad Only)
    QMAKE_APPLE_TARGETED_DEVICE_FAMILY = 1
}

DISTFILES += \
    Doc/notes.txt \
    Ladeklubben.pri \
    icons/creditcard.svg \
    icons/ev_type1.png \
    icons/ev_type2.png \
    icons/ev_type2comboCCS.png \
    icons/ev_typechademo.png \
    icons/logo.svg \
    icons/logo_invert.svg \
    icons/logo_white.svg

#languages/lk_dk.ts

TRANSLATIONS = translations/lk_dk.ts
