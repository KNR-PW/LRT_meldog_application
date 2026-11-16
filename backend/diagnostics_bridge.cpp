#include "backend/diagnostics_bridge.hpp"

namespace backend {

DiagnosticsBridge::DiagnosticsBridge(QObject* parent)
    : QObject(parent)
{
}

void DiagnosticsBridge::updateJoint(
    const QString& name,
    double position)
{
    emit jointUpdated(name, position);
}

}