#pragma once

#include <QObject>
#include <QProcess>
#include <QString>

namespace backend {

class AppController final : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool rvizRunning READ rvizRunning NOTIFY rvizRunningChanged)
    Q_PROPERTY(QString rvizStatus READ rvizStatus NOTIFY rvizStatusChanged)

public:
    explicit AppController(QObject* parent = nullptr);
    ~AppController() override;

    bool rvizRunning() const;
    QString rvizStatus() const;

    Q_INVOKABLE void launchRviz();
    Q_INVOKABLE void stopRviz();

signals:
    void rvizRunningChanged();
    void rvizStatusChanged();

private slots:
    void handleStarted();
    void handleFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void handleError(QProcess::ProcessError error);

private:
    void setRvizRunning(bool running);
    void setRvizStatus(const QString& status);

    QProcess* rvizProcess_ = nullptr;
    bool rvizRunning_ = false;
    QString rvizStatus_ = "RViz is not running.";
};

} 