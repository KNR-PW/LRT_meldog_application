#pragma once

#include <QObject>
#include <QString>

namespace backend {
class AppController final : public QObject {
    Q_OBJECT

public:
    explicit AppController(QObject* parent = nullptr);
    
public slots:

signals:

private:
};
}