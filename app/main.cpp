#include <QApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QUrl>

#include "backend/app_controller.hpp"
#include "backend/gamepad_controller.hpp"

int main(int argc, char** argv) {
  QApplication app(argc, argv);

  backend::AppController appController;
  backend::GamepadController gamepadController;

  QQuickView view;
  view.rootContext()->setContextProperty("appController", &appController);
  view.rootContext()->setContextProperty("gamepadController", &gamepadController);
  view.setResizeMode(QQuickView::SizeRootObjectToView);
  view.setSource(QUrl("qrc:/main.qml"));
  view.showMaximized();

  return app.exec();
}