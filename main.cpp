#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtWebView/QtWebView>
#include <QtGui>
#include <QtQuick>
#include <QDebug>
#include <QSslConfiguration>
#include <QSslSocket>
#include "pushnotification.h"
#include <QZXing.h>
#include <QPermissions>

int main(int argc, char *argv[])
{
    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGLRhi);

    qmlRegisterType<PushNotification>("PushNotification", 1, 0, "PushNotification");
    QZXing::registerQMLTypes();

    QtWebView::initialize();
    QApplication app(argc, argv);


    QFont fon("Cantarell", 11);
    app.setFont(fon);
    app.setOrganizationName("Ladeklubben");
    app.setOrganizationDomain("ladeklubben.dk");
    app.setApplicationName("Ladeklubben");
    app.setApplicationVersion(APP_VERSION);

    QtWebView::initialize();

    QSslConfiguration config = QSslConfiguration::defaultConfiguration();
    config.setPeerVerifyMode(QSslSocket::VerifyNone);
    QSslConfiguration::setDefaultConfiguration(config);

    QTranslator translator;
    if (translator.load(":/translations/Ladeklubben_dk.qm"))
    {
        app.installTranslator(&translator);
    } else {
        qDebug() << "cannot load translator " << QLocale::system().name() << " check content of translations.qrc";
    }


    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("qtversion", QString(qVersion()));
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}


