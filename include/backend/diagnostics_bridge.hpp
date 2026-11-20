
#pragma once

#include <QObject>
#include <QString>
#include <vector>
#include <utility>
#include <functional>
#include <QVariant>
#include <string>


namespace backend {

class DiagnosticsBridge : public QObject
{
    Q_OBJECT

public:
    explicit DiagnosticsBridge(QObject* parent = nullptr);
    void updateJoint(const QString& name, double position);
    void updateMonitoredTopics(QVariantList topics);
    void updateTopicFrequencies(const std::vector<std::pair<std::string, double>>& frequencies);

signals:
    void jointUpdated(QString name, double position);
    void topicFrequenciesUpdated(QVariantList topics);
};

}
