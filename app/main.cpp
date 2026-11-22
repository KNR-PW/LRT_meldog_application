
#include <QApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QUrl>
#include <QTimer>
#include <QQuickWindow>
#include <QStringList>
#include <QVariant>

#include <memory>
#include <rclcpp/rclcpp.hpp>

#include "backend/app_controller.hpp"
#include "backend/diagnostics_node.hpp"
#include "backend/diagnostics_bridge.hpp"

int main(int argc, char** argv)
{
    
    qputenv("LIBGL_ALWAYS_SOFTWARE", "1");

    rclcpp::init(argc, argv);

    QApplication app(argc, argv);
    backend::AppController appController;


    
    auto diagnosticsNode =
        std::make_shared<backend::DiagnosticsNode>();

    backend::DiagnosticsBridge diagnosticsBridge;

    diagnosticsNode->setJointUpdateCallback(
        [&diagnosticsBridge](const std::string& name, double position) {
            diagnosticsBridge.updateJoint(QString::fromStdString(name), position);
        }
    );

    diagnosticsNode->setTopicFrequenciesCallback(
        [&diagnosticsBridge](const std::vector<std::pair<std::string, double>>& frequencies) {
            diagnosticsBridge.updateTopicFrequencies(frequencies);
        }
    );

    QObject::connect(
        &diagnosticsBridge,
        &backend::DiagnosticsBridge::addTopicRequested,
        [&diagnosticsNode](const QString& name) {
            diagnosticsNode->addMonitoredTopic(name.toStdString());
        }
    );

    QObject::connect(
        &diagnosticsBridge,
        &backend::DiagnosticsBridge::removeTopicRequested,
        [&diagnosticsNode](const QString& name) {
            diagnosticsNode->removeMonitoredTopic(name.toStdString());
        }
    );

    
    rclcpp::executors::SingleThreadedExecutor executor;
    executor.add_node(diagnosticsNode);

    QTimer rosTimer;
    QObject::connect(
        &rosTimer,
        &QTimer::timeout,
        [&executor]() {

            if (!rclcpp::ok()) {
                QApplication::quit();
                return;
            }
            executor.spin_some();
        }
    );

    rosTimer.start(10);


    QQuickView view;
    view.rootContext()->setContextProperty(
        "appController", &appController);
    view.rootContext()->setContextProperty("diagnosticsBridge", &diagnosticsBridge);

    view.setResizeMode(
        QQuickView::SizeRootObjectToView);
    view.setSource(QUrl("qrc:/main.qml"));
    view.showMaximized();

    
    int result = app.exec();

    rosTimer.stop();
    executor.remove_node(diagnosticsNode);
    diagnosticsNode.reset();
    rclcpp::shutdown();

    return result;
}