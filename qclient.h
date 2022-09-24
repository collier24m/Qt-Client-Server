#ifndef QCLIENT_H
#define QCLIENT_H
#include <QObject>
#include "connectionStatusEnum.h"

//enum class ConnectionStatus;
class QClient: public QObject
{
    Q_OBJECT

public:
    explicit QClient(QObject *parent = nullptr);



    Q_INVOKABLE void connectToServer(QString wifiID,QString password);
    Q_PROPERTY(ConnectionStatus::Enum connectionStatus READ connectionStatus NOTIFY connectionStatusChanged)

signals:
    void connectionStatusChanged();
    void error(QString msg);
    void verifyPassword(QString id,QString pass);

public:
    ConnectionStatus::Enum connectionStatus() const;


public slots:
    void setConnectionStatus(ConnectionStatus::Enum newStatus);

private:
    //QString m_connectionStatus;
    ConnectionStatus::Enum m_connectionStatus= ConnectionStatus::Enum::Initial;
};

#endif // QCLIENT_H
