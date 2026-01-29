#include <QApplication>
#include <QQuickView>
#include <QUrl>

int main(int argc, char** argv) {
  QApplication app(argc, argv);

  QQuickView view;
  view.setResizeMode(QQuickView::SizeRootObjectToView);
  view.setSource(QUrl("qrc:/main.qml"));
  view.showMaximized();
  return app.exec();
}
