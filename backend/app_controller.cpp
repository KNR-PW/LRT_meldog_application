#include "backend/app_controller.hpp"

#include <QDebug>
#include <QProcessEnvironment>

namespace backend {

AppController::AppController(QObject* parent)
    : QObject(parent),
      rvizProcess_(new QProcess(this))
{
    rvizProcess_->setProcessChannelMode(QProcess::MergedChannels);

    connect(rvizProcess_, &QProcess::started,
            this, &AppController::handleStarted);

    connect(rvizProcess_,
            qOverload<int, QProcess::ExitStatus>(&QProcess::finished),
            this, &AppController::handleFinished);

    connect(rvizProcess_, &QProcess::errorOccurred,
            this, &AppController::handleError);

    connect(rvizProcess_, &QProcess::readyReadStandardOutput, this, [this]() {
        const QByteArray data = rvizProcess_->readAllStandardOutput();
        qDebug().noquote() << "[RVIZ STDOUT/ERR]" << QString::fromLocal8Bit(data);
    });
}

AppController::~AppController()
{
    stopRviz();
}

bool AppController::rvizRunning() const
{
    return rvizRunning_;
}

QString AppController::rvizStatus() const
{
    return rvizStatus_;
}

void AppController::launchRviz()
{
    if (!rvizProcess_) {
        return;
    }

    if (rvizProcess_->state() != QProcess::NotRunning) {
        setRvizStatus("RViz is already running.");
        qDebug() << "RViz already running.";
        return;
    }

    setRvizStatus("Starting RViz...");
    qDebug() << "launchRviz called";

    const QString program = "ros2";
    const QStringList arguments{
        "launch",
        "meldog_description",
        "meldog_rviz.launch.xml"
    };

    qDebug() << "Program:" << program;
    qDebug() << "Arguments:" << arguments;
    qDebug() << "PATH:" << QProcessEnvironment::systemEnvironment().value("PATH");
    qDebug() << "AMENT_PREFIX_PATH:" << QProcessEnvironment::systemEnvironment().value("AMENT_PREFIX_PATH");
    qDebug() << "ROS_DISTRO:" << QProcessEnvironment::systemEnvironment().value("ROS_DISTRO");

    rvizProcess_->start(program, arguments);
}

void AppController::stopRviz()
{
    if (!rvizProcess_) {
        return;
    }

    if (rvizProcess_->state() == QProcess::NotRunning) {
        return;
    }

    setRvizStatus("Stopping RViz...");
    rvizProcess_->terminate();

    if (!rvizProcess_->waitForFinished(3000)) {
        rvizProcess_->kill();
        rvizProcess_->waitForFinished(1000);
    }
}

void AppController::handleStarted()
{
    qDebug() << "RViz process started.";
    setRvizRunning(true);
    setRvizStatus("RViz is running.");
}

void AppController::handleFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    qDebug() << "RViz process finished. exitCode =" << exitCode
             << "exitStatus =" << exitStatus;

    setRvizRunning(false);

    if (exitStatus == QProcess::CrashExit) {
        setRvizStatus(QString("RViz closed unexpectedly. Exit code: %1").arg(exitCode));
    } else {
        setRvizStatus(QString("RViz closed. Exit code: %1").arg(exitCode));
    }
}

void AppController::handleError(QProcess::ProcessError error)
{
    qDebug() << "QProcess error:" << error;
    qDebug() << "Error string:" << rvizProcess_->errorString();

    setRvizRunning(false);

    switch (error) {
    case QProcess::FailedToStart:
        setRvizStatus("Failed to start ros2 launch. Run the app from a sourced ROS 2 shell.");
        break;
    case QProcess::Crashed:
        setRvizStatus("RViz process crashed.");
        break;
    default:
        setRvizStatus(QString("RViz process error: %1").arg(rvizProcess_->errorString()));
        break;
    }
}

void AppController::setRvizRunning(bool running)
{
    if (rvizRunning_ == running) {
        return;
    }

    rvizRunning_ = running;
    emit rvizRunningChanged();
}

void AppController::setRvizStatus(const QString& status)
{
    if (rvizStatus_ == status) {
        return;
    }

    rvizStatus_ = status;
    emit rvizStatusChanged();
}

} 