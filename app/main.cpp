
#include <QApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QUrl>
#include <QTimer>             // NOWE
#include <QQuickWindow>

#include <memory>             // NOWE
#include <rclcpp/rclcpp.hpp>  // NOWE

#include "backend/app_controller.hpp"
#include "backend/diagnostics_node.hpp" // NOWE

int main(int argc, char** argv)
{
    
    qputenv("LIBGL_ALWAYS_SOFTWARE", "1");

    rclcpp::init(argc, argv); // NOWE

    QApplication app(argc, argv);
    backend::AppController appController;


    // NOWE: utworzenie Subscribera
    auto diagnosticsNode =
        std::make_shared<backend::DiagnosticsNode>();

    // NOWE: executor ROS 2
    rclcpp::executors::SingleThreadedExecutor executor;
    executor.add_node(diagnosticsNode);

    // NOWE: timer obsługujący ROS 2
    QTimer rosTimer;
    QObject::connect(
        &rosTimer,
        &QTimer::timeout,
        [&executor]() {
            executor.spin_some();
        }
    );
    rosTimer.start(10);

    // BEZ ZMIAN: okno Qt
    QQuickView view;
    view.rootContext()->setContextProperty(
        "appController", &appController);

    view.setResizeMode(
        QQuickView::SizeRootObjectToView);
    view.setSource(QUrl("qrc:/main.qml"));
    view.showMaximized();

    // ZMIENIONE: zamykanie programu
    int result = app.exec();

    rosTimer.stop();
    executor.remove_node(diagnosticsNode);
    diagnosticsNode.reset();
    rclcpp::shutdown();

    return result;
}