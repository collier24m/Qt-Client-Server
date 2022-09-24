#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "qserver.h"
#include "qclient.h"
#include "connectionStatusEnum.h"
/*
 * Code by: Matthew Collier
 * 9/21/22
 *
 * Important Notes:
 * -Obtained Icons from IconScout.com
 * -connectButton clicked (Q_Invokable) -> QServer verify wifiID + password
 * -QServer sends status to Client via Signals/Slots using ConnectionStatus Enum
 *
 * -Created Connection Status Enum to send status instead of using QStrings. This Enum will be used to change the color of the Wifi signal
 * -Added some error handling connection error signals from server to client to notify user
 *
 */


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QServer server;
    QClient client;

    //Need to connect signal and slots of server and client
    QObject::connect(&server,SIGNAL(error(QString)),&client,SIGNAL(error(QString)));
    QObject::connect(&server,SIGNAL(sendStatusToClient(ConnectionStatus::Enum)),&client,SLOT(setConnectionStatus(ConnectionStatus::Enum)));

    QObject::connect(&client,SIGNAL(verifyPassword(QString,QString)),&server,SLOT(verifyPassword(QString,QString)));

    //Register Type ConnectionStatus Enum in QML
    qmlRegisterUncreatableType<ConnectionStatus>("connectionStatusEnum", 1, 0, "ConnectionStatus",
                                                 "Cannot create WarningLevel in QML");

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("Client", &client);
    engine.rootContext()->setContextProperty("Server", &server);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);


    return app.exec();
}
