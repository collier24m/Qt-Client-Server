#ifndef CONNECTIONSTATUSENUM_H
#define CONNECTIONSTATUSENUM_H
#include <QObject>
class ConnectionStatus : public QObject
{
    Q_OBJECT
public:
    enum class Enum : quint8 {
        Initial,
        Successful,
        Failed


    };
    Q_ENUM(Enum)
};

#endif // CONNECTIONSTATUSENUM_H
