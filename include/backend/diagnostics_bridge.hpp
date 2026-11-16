
#pragma once

#include <QObject>
#include <QString>

namespace backend {

class DiagnosticsBridge : public QObject
{
    Q_OBJECT

public:
    explicit DiagnosticsBridge(QObject* parent = nullptr);
    void updateJoint(const QString& name, double position);

signals:
    void jointUpdated(QString name, double position);
};

}
