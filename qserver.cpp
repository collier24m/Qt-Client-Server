#include "qserver.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QCoreApplication>
QServer::QServer(QObject *parent)
    :  QObject{parent}

{
    initialize();
}


void QServer::initialize()
{
    qDebug() << "QServer intialized";
    file.setFileName("test.json");
    if(file.open( QIODevice::ReadOnly ) )
    {
        qDebug() << "file opened";

        QByteArray bytes = file.readAll();
        file.close();

        QJsonParseError jsonError;
        QJsonDocument document = QJsonDocument::fromJson( bytes, &jsonError );
        if( jsonError.error != QJsonParseError::NoError )
        {
            qInfo() << "fromJson failed: " << jsonError.errorString();
            emit error(jsonError.errorString());
            return ;
        }
        if( document.isObject() )
        {
            QJsonObject jsonObj = document.object();
            QJsonArray jsonArray = jsonObj["wifi_params"].toArray();
            foreach (const QJsonValue & value, jsonArray) {
                QJsonObject obj = value.toObject();
                map.insert(obj["id"].toString(),obj["auth"].toString());
                m_wifiIDs.append(obj["id"].toString());
            }
        }



//        QMapIterator<QString, QString> i(map);
//        while (i.hasNext()) {
//            i.next();
//            //m_wifiIDs.append(i.key());
//            qInfo() << i.key() << ": " << i.value() << Qt::endl;
//        }

        qInfo() << "QStringList: " << m_wifiIDs << Qt::endl;
    }
}

void QServer::verifyPassword(QString id, QString password)
{
    qInfo() << "QSERVER verifyPAssword";
    QMapIterator<QString, QString> i(map);
    if (map.contains(id)){
        if(password == map.value(id)){
            emit sendStatusToClient(ConnectionStatus::Enum::Successful);

        }
        else{
            emit error("Password is incorrect");
            emit sendStatusToClient(ConnectionStatus::Enum::Failed);

        }
    }

}
