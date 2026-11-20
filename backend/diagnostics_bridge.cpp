#include "backend/diagnostics_bridge.hpp"
#include <QVariant>
#include <vector>
#include <string>
#include <utility>
#include <QString>

namespace backend {

DiagnosticsBridge::DiagnosticsBridge(QObject* parent): QObject(parent)
{
}

void DiagnosticsBridge::updateJoint(const QString& name, double position)
{
    emit jointUpdated(name, position);
}


void DiagnosticsBridge::updateTopicFrequencies(
    const std::vector<std::pair<std::string, double>>& frequencies)
{
    QVariantList topics;

    for (const auto& [name, hz] : frequencies) {

        QVariantMap topic;

        topic["name"] = QString::fromStdString(name);
        topic["frequency"] = hz;

        topics.append(topic);
    }
    emit topicFrequenciesUpdated(topics);
}



}