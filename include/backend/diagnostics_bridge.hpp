
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

    Q_INVOKABLE void addTopic(const QString& name);
    Q_INVOKABLE void removeTopic(const QString& name);

signals:
    void jointUpdated(QString name, double position);
    void topicFrequenciesUpdated(QVariantList topics);
    
    void addTopicRequested(QString name);
    void removeTopicRequested(QString name);
};

}
