#include "qclient.h"
#include <QDebug>

/* Important Signals/Slots
 * connectButton clicked -> slot connectclicked
 *
 * Q_Property connectionStatus (connection success/unsuccessful for wifi icon)
 *
 */


QClient::QClient(QObject *parent)
    :  QObject{parent}
{

}

void QClient::connectToServer(QString wifiID, QString password)
{

    qInfo() << "connect clicked! " << "wifiID + password " << wifiID << " " << password;

    //first check if password is good
    if(!(password.front().isDigit()) && !(password.count() < 16)){
        //qInfo() << "good password...verify emit";
        emit verifyPassword(wifiID,password);

    }
    else{
        emit error("Password must not begin with a number and must be 16 characters long");
    }

}


ConnectionStatus::Enum QClient::connectionStatus() const
{
    return m_connectionStatus;
}

void QClient::setConnectionStatus(ConnectionStatus::Enum newStatus)
{
    qInfo() << "newStatus: " << newStatus;
    if (m_connectionStatus != newStatus) {
                m_connectionStatus = newStatus;
                qInfo() << "m_connectionStatus: " << newStatus;
                emit connectionStatusChanged();
            }
}

