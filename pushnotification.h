#ifndef PUSHNOTIFICATION_H
#define PUSHNOTIFICATION_H
#include <QObject>
#include <QUdpSocket>
#include <QTimer>
#include <QtNetwork>
#include <QNetworkInformation>

class PushNotification: public QObject
{
    Q_OBJECT
public:
    PushNotification(QObject *parent = nullptr);
    ~PushNotification();

    bool startService();

    Q_PROPERTY(int appid MEMBER m_appid NOTIFY appidChanged)
    Q_PROPERTY(QString clientid MEMBER m_clientid)
    Q_PROPERTY(bool enable READ enabled WRITE enable NOTIFY enableChanged)
    Q_PROPERTY(QMap<QString, QVariant> data_extra MEMBER m_data_extra)

    void enable(bool);
    bool enabled(){return m_enable;}

public slots:
    void setCredentials(QString clientid, qint32 appid);
    void forceUpdate();

private:
    Q_DISABLE_COPY(PushNotification)
    QUdpSocket* udpSocket = nullptr;
    QNetworkInformation *ncm;

    QTimer* ka_connection; //Keep alive for NAT transversal
    QTimer* ka_appid;      //Keep alive for server to keep pushing

    int suspended = 0;
    int m_appid = -1;
    QString m_clientid = "";
    QMap<QString, QVariant> m_data_extra;
    bool m_enable = false;

    qint64 nextAppid_ka;
    qint64 next_conn_ka;

    void initSocket();
    void processTheDatagram(QNetworkDatagram datagram);
    bool handleMessage(QVariantMap msg);

private slots:
    void handleApplicationStateChange(Qt::ApplicationState state);

    // Renamed to clarify they're event handlers
    void onNetworkReachabilityChanged(QNetworkInformation::Reachability newReachability);
    void onTransportMediumChanged(QNetworkInformation::TransportMedium current);

    // Renamed socket event handlers
    void onSocketConnected();
    void onSocketDisconnected();
    void onSocketReadyRead();

    void keepaliveTimeout();

signals:
    void appidChanged(int appid);
    void enableChanged();
    void messageReceived(QByteArray msg);
};

#endif // PUSHNOTIFICATION_H
