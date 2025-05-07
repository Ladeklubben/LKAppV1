#include "pushnotification.h"
#include <QGuiApplication>
#include <QMetaObject>

#define APPID_KEEPALIVE_SEC 8*60
#define CONN_KEEPALIVE_SEC 0.5*60

PushNotification::PushNotification(QObject *parent)
    : QObject(parent){
    nextAppid_ka = QDateTime::currentSecsSinceEpoch();
    next_conn_ka = QDateTime::currentSecsSinceEpoch();

    ka_connection = new QTimer(this);
    ka_connection->setSingleShot(true);

    connect(ka_connection, &QTimer::timeout, this, &PushNotification::keepaliveTimeout);

    ka_appid = new QTimer(this);
    ka_appid->setSingleShot(true);

    connect(ka_appid, &QTimer::timeout, this, &PushNotification::keepaliveTimeout);

    // Make sure this runs on the main thread
    QMetaObject::invokeMethod(this, [this]() {
        QGuiApplication* application = qobject_cast<QGuiApplication*>(QGuiApplication::instance());
        if (application) {
            connect(application, SIGNAL(applicationStateChanged(Qt::ApplicationState)),
                    this, SLOT(handleApplicationStateChange(Qt::ApplicationState)));
        }
    }, Qt::QueuedConnection);

    QNetworkInformation::loadDefaultBackend();
    ncm = QNetworkInformation::instance();
    if(ncm){
        connect(ncm, &QNetworkInformation::reachabilityChanged, this, &PushNotification::onNetworkReachabilityChanged);
        connect(ncm, &QNetworkInformation::transportMediumChanged, this, &PushNotification::onTransportMediumChanged);
    }

    udpSocket = new QUdpSocket(this);
    if(udpSocket->bind(QHostAddress::AnyIPv4)){
        qDebug() << "Successfully bound to port" << udpSocket->localPort();
    }

    connect(udpSocket, &QUdpSocket::readyRead,
            this, &PushNotification::onSocketReadyRead);
    connect(udpSocket, &QUdpSocket::connected, this, &PushNotification::onSocketConnected);
    connect(udpSocket, &QUdpSocket::disconnected, this, &PushNotification::onSocketDisconnected);
}

PushNotification::~PushNotification()
{
    qDebug() << "Destroy pushnotification";
    udpSocket->abort();
    udpSocket->deleteLater();
    ka_appid->stop();
    ka_connection->stop();
    ka_appid->deleteLater();
    ka_connection->deleteLater();
    ncm->disconnect();
}

void PushNotification::handleApplicationStateChange(Qt::ApplicationState state)
{
    if (state == Qt::ApplicationSuspended) {
        qDebug() << "Suspended";
        suspended = 1;
        udpSocket->abort();
    }
    else if(state == Qt::ApplicationActive) {
        qDebug() << "ApplicationActive";
        if(!suspended) return;
        suspended = 0;
        ka_appid->stop();
        ka_connection->stop();
        udpSocket->connectToHost("client.ladeklubben.dk", 63000);
    }
}

void PushNotification::onNetworkReachabilityChanged(QNetworkInformation::Reachability newReachability){
    // Ensure we're on the main thread for any UI updates
    QMetaObject::invokeMethod(this, [this, newReachability]() {
        qDebug()<< "onlineStateChanged emited " << newReachability;
        if(newReachability == QNetworkInformation::Reachability::Disconnected){
            ka_appid->stop();
            ka_connection->stop();
            udpSocket->abort();
        }
        else if(newReachability == QNetworkInformation::Reachability::Online){
            if(!ka_appid->isActive()){
                initSocket();
            }
        }
    }, Qt::QueuedConnection);
}

void PushNotification::onTransportMediumChanged(QNetworkInformation::TransportMedium current){
    // Ensure we're on the main thread for any UI updates
    QMetaObject::invokeMethod(this, [this, current]() {
        qDebug()<< "transportMediumChanged emited " << current;
    }, Qt::QueuedConnection);
}

void PushNotification::enable(bool en){
    if(en == m_enable) return;
    if(m_clientid.compare("") == 0) return;

    // Ensure we're on the main thread
    QMetaObject::invokeMethod(this, [this, en]() {
        if(en){
            m_enable = true;
            initSocket();
        }
        else{
            ka_appid->stop();
            ka_connection->stop();
            udpSocket->abort();
            m_enable = false;
        }
        emit enableChanged();
    }, Qt::QueuedConnection);
}

void PushNotification::initSocket()
{
    qDebug() << "Init socket";
    udpSocket->connectToHost("client.ladeklubben.dk", 63000);
}

void PushNotification::onSocketConnected(){
    // Ensure we're on the main thread
    QMetaObject::invokeMethod(this, [this]() {
        qDebug() << "Connection connected";
        startService();
    }, Qt::QueuedConnection);
}

void PushNotification::onSocketDisconnected(){
    // Ensure we're on the main thread
    QMetaObject::invokeMethod(this, [this]() {
        qDebug() << "Connection disconnected";
    }, Qt::QueuedConnection);
}

bool PushNotification::handleMessage(QVariantMap msg){
    bool handled = false;
    if(msg["msgtype"].toString().compare("appidupd") == 0){
        qDebug() << "Recevied an APPid";
        m_appid = msg["appid"].toInt();

        // Ensure we emit signals on the main thread
        QMetaObject::invokeMethod(this, [this]() {
            emit appidChanged(m_appid);
        }, Qt::QueuedConnection);

        handled = true;
    }

    return handled;
}

void PushNotification::processTheDatagram(QNetworkDatagram datagram){
    QJsonParseError err;
    QJsonDocument rxmsg = QJsonDocument::fromJson(datagram.data(), &err);
    //qDebug() << "processTheDatagram";
    if(err.error == QJsonParseError::NoError){
        if(handleMessage(rxmsg.toVariant().toMap())) return;

        // Ensure we emit signals on the main thread
        QByteArray msgData = datagram.data();
        QMetaObject::invokeMethod(this, [this, msgData]() {
            emit messageReceived(msgData);
        }, Qt::QueuedConnection);
    }
    else{
        qDebug() << err.errorString();
    }
}

void PushNotification::onSocketReadyRead()
{
    // Ensure we're on the main thread
    QMetaObject::invokeMethod(this, [this]() {
        next_conn_ka = QDateTime::currentSecsSinceEpoch() + static_cast<qint64>(CONN_KEEPALIVE_SEC);
        ka_connection->start(static_cast<qint64>(CONN_KEEPALIVE_SEC*1000));

        while (udpSocket->hasPendingDatagrams()) {
            QNetworkDatagram datagram = udpSocket->receiveDatagram();
            processTheDatagram(datagram);
        }
    }, Qt::QueuedConnection);
}

bool PushNotification::startService()
{
    nextAppid_ka = QDateTime::currentSecsSinceEpoch() + static_cast<qint64>(APPID_KEEPALIVE_SEC);
    next_conn_ka = QDateTime::currentSecsSinceEpoch() + static_cast<qint64>(CONN_KEEPALIVE_SEC);

    ka_connection->start(static_cast<qint64>(CONN_KEEPALIVE_SEC*1000));
    ka_appid->start(APPID_KEEPALIVE_SEC*1000);
    QJsonObject json;
    json["id"] = m_clientid;
    if(m_appid >= 0){
        json["appid"] = m_appid;
    }

    QMapIterator<QString, QVariant> i(m_data_extra);
    while (i.hasNext()) {
        i.next();
        json.insert(i.key(), QJsonValue::fromVariant(i.value()));
    }
    udpSocket->write(QJsonDocument(json).toJson());
    return false;
}

void PushNotification::keepaliveTimeout(){
    // Ensure we're on the main thread
    QMetaObject::invokeMethod(this, [this]() {
        startService();
    }, Qt::QueuedConnection);
}

void PushNotification::setCredentials(QString clientid, qint32 appid){
    // Ensure we're on the main thread
    QMetaObject::invokeMethod(this, [this, clientid, appid]() {
        m_clientid = clientid;
        m_appid = appid;
    }, Qt::QueuedConnection);
}

void PushNotification::forceUpdate(){
    // Ensure we're on the main thread
    QMetaObject::invokeMethod(this, [this]() {
        if(udpSocket->state() == QAbstractSocket::SocketState::ConnectedState)
            startService();
    }, Qt::QueuedConnection);
}
