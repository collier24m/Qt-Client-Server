#ifndef QSERVER_H
#define QSERVER_H

//#include <QAbstractListModel>
//#include <QStringListModel>
#include <QFile>
#include <QMap>
#include "connectionStatusEnum.h"
class QServer : public QObject
{
    Q_OBJECT

   Q_PROPERTY(QStringList wifiIDs MEMBER m_wifiIDs NOTIFY wifiIDsChanged)
public:
    explicit QServer(QObject *parent = nullptr);



public:

public slots:
    void verifyPassword(QString id,QString password);

signals:
    void error(QString);
    void wifiIDsChanged();
    //void connectionStatusChanged(QString status);
    void sendStatusToClient(ConnectionStatus::Enum status);
private:
    void initialize();
    void setConnectionStatus(const QString &status);
    QFile file;
    QStringList m_wifiIDs;
    QMap<QString,QString> map;

};

#endif // QSERVER_H
