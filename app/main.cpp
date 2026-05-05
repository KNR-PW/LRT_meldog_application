#include <QApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QUrl>

#include "backend/app_controller.hpp"

int main(int argc, char** argv) {
  QApplication app(argc, argv);

  backend::AppController appController;

  QQuickView view;
  view.rootContext()->setContextProperty("appController", &appController);
  view.setResizeMode(QQuickView::SizeRootObjectToView);
  view.setSource(QUrl("qrc:/main.qml"));
  view.showMaximized();

  return app.exec();
}