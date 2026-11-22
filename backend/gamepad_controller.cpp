#include "backend/gamepad_controller.hpp"

#include <QDebug>

#include <cerrno>
#include <cmath>
#include <cstdint>
#include <fcntl.h>
#include <linux/joystick.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <vector>

namespace backend {

namespace {
constexpr int kReconnectIntervalMs = 500;
constexpr int kHoldCheckIntervalMs = 25;
constexpr int kAxisButtonThreshold = 16000;
constexpr int kMaxJoystickDevices = 4;
constexpr double kStickChangeEpsilon = 0.02;
}  // namespace

GamepadController::GamepadController(QObject* parent)
    : QObject(parent),
      reconnectTimer_(new QTimer(this)),
      holdCheckTimer_(new QTimer(this))
{
    loadDefaultMappings();

    reconnectTimer_->setInterval(kReconnectIntervalMs);
    connect(reconnectTimer_, &QTimer::timeout,
            this, &GamepadController::tryConnect);

    holdCheckTimer_->setInterval(kHoldCheckIntervalMs);
    connect(holdCheckTimer_, &QTimer::timeout,
            this, &GamepadController::checkHoldStates);

    tryConnect();
    if (!connected_) {
        reconnectTimer_->start();
    }
}

GamepadController::~GamepadController()
{
    disconnectDevice();
}

bool GamepadController::connected() const
{
    return connected_;
}

QString GamepadController::deviceName() const
{
    return deviceName_;
}

int GamepadController::holdThresholdMs() const
{
    return holdThresholdMs_;
}

void GamepadController::setHoldThresholdMs(int thresholdMs)
{
    if (thresholdMs < 50 || holdThresholdMs_ == thresholdMs) {
        return;
    }

    holdThresholdMs_ = thresholdMs;
    emit holdThresholdMsChanged(holdThresholdMs_);
}

void GamepadController::mapButton(Button button, PressType pressType, Action action)
{
    actionMap_[{button, pressType}] = action;
}

void GamepadController::clearMapping(Button button, PressType pressType)
{
    actionMap_.erase({button, pressType});
}

void GamepadController::registerActionHandler(Action action, std::function<void()> callback)
{
    actionHandlers_[action] = std::move(callback);
}

void GamepadController::mapStick(Stick stick, AxisAction action)
{
    axisActionMap_[stick] = action;
}

void GamepadController::clearStickMapping(Stick stick)
{
    axisActionMap_.erase(stick);
}

void GamepadController::registerAxisActionHandler(
    AxisAction action,
    std::function<void(double, double)> callback)
{
    axisActionHandlers_[action] = std::move(callback);
}

QString GamepadController::buttonToString(Button button) const
{
    switch (button) {
    case Button::A: return "A";
    case Button::B: return "B";
    case Button::X: return "X";
    case Button::Y: return "Y";
    case Button::L1: return "L1";
    case Button::R1: return "R1";
    case Button::L2: return "L2";
    case Button::R2: return "R2";
    case Button::Back: return "Back";
    case Button::Start: return "Start";
    case Button::Guide: return "Guide";
    case Button::L3: return "L3";
    case Button::R3: return "R3";
    case Button::DpadUp: return "DpadUp";
    case Button::DpadDown: return "DpadDown";
    case Button::DpadLeft: return "DpadLeft";
    case Button::DpadRight: return "DpadRight";
    }
    return "Unknown";
}

QString GamepadController::actionToString(Action action) const
{
    switch (action) {
    case Action::None: return "None";
    case Action::SwitchPagePrev: return "SwitchPagePrev";
    case Action::SwitchPageNext: return "SwitchPageNext";
    case Action::SwitchSubpagePrev: return "SwitchSubpagePrev";
    case Action::SwitchSubpageNext: return "SwitchSubpageNext";
    case Action::SelectJointPrev: return "SelectJointPrev";
    case Action::SelectJointNext: return "SelectJointNext";
    case Action::MoveJointUp: return "MoveJointUp";
    case Action::MoveJointDown: return "MoveJointDown";
    case Action::DoMeldogFlip: return "DoMeldogFlip";
    case Action::StartPosition: return "StartPosition";
    case Action::ResetPosition: return "ResetPosition";
    case Action::FocusPreset: return "FocusPreset";
    case Action::EmergencyStop: return "EmergencyStop";
    }
    return "Unknown";
}

QString GamepadController::axisActionToString(AxisAction action) const
{
    switch (action) {
    case AxisAction::None: return "None";
    case AxisAction::RvizOrbitRotate: return "RvizOrbitRotate";
    case AxisAction::RvizPan: return "RvizPan";
    }
    return "Unknown";
}

void GamepadController::loadDefaultMappings()
{
    // Pojedyncze klikniecia (zgodne z ekranem GAMEPAD CONTROLS)
    mapButton(Button::L1, PressType::SingleClick, Action::SwitchPagePrev);
    mapButton(Button::R1, PressType::SingleClick, Action::SwitchPageNext);
    mapButton(Button::L2, PressType::SingleClick, Action::SwitchSubpagePrev);
    mapButton(Button::R2, PressType::SingleClick, Action::SwitchSubpageNext);

    mapButton(Button::DpadLeft, PressType::SingleClick, Action::SelectJointPrev);
    mapButton(Button::DpadRight, PressType::SingleClick, Action::SelectJointNext);
    mapButton(Button::DpadUp, PressType::SingleClick, Action::MoveJointUp);
    mapButton(Button::DpadDown, PressType::SingleClick, Action::MoveJointDown);

    mapButton(Button::A, PressType::SingleClick, Action::DoMeldogFlip);
    mapButton(Button::B, PressType::SingleClick, Action::StartPosition);
    mapButton(Button::Y, PressType::SingleClick, Action::ResetPosition);

    // Przytrzymania (Hold)
    mapButton(Button::B, PressType::Hold, Action::EmergencyStop);
    mapButton(Button::Y, PressType::Hold, Action::FocusPreset);

    // Galki analogowe (RVIZ: R-STICK Orbit / Rotate, L-STICK Pan)
    mapStick(Stick::RightStick, AxisAction::RvizOrbitRotate);
    mapStick(Stick::LeftStick, AxisAction::RvizPan);
}

void GamepadController::tryConnect()
{
    if (connected_) {
        return;
    }

    for (int idx = 0; idx < kMaxJoystickDevices; ++idx) {
        const QString path = QString("/dev/input/js%1").arg(idx);
        const int fd = ::open(path.toLocal8Bit().constData(), O_RDONLY | O_NONBLOCK);
        if (fd < 0) {
            continue;
        }

        fd_ = fd;

        char nameBuffer[128] = {};
        QString detectedName = path;
        if (::ioctl(fd_, JSIOCGNAME(sizeof(nameBuffer)), nameBuffer) >= 0) {
            detectedName = QString::fromLocal8Bit(nameBuffer);
        }

        socketNotifier_ = new QSocketNotifier(fd_, QSocketNotifier::Read, this);
        connect(socketNotifier_, &QSocketNotifier::activated,
                this, &GamepadController::handleReadyRead);

        reconnectTimer_->stop();
        holdCheckTimer_->start();

        setDeviceName(detectedName);
        setConnected(true);

        qDebug() << "[Gamepad] Connected:" << deviceName_ << "at" << path;
        return;
    }
}

void GamepadController::disconnectDevice()
{
    const bool wasConnected = connected_;

    holdCheckTimer_->stop();
    buttonStates_.clear();

    leftStickX_ = 0.0;
    leftStickY_ = 0.0;
    rightStickX_ = 0.0;
    rightStickY_ = 0.0;

    if (socketNotifier_) {
        socketNotifier_->setEnabled(false);
        socketNotifier_->deleteLater();
        socketNotifier_ = nullptr;
    }

    if (fd_ >= 0) {
        ::close(fd_);
        fd_ = -1;
    }

    setConnected(false);
    setDeviceName(QString());

    if (wasConnected) {
        qDebug() << "[Gamepad] Disconnected.";
        reconnectTimer_->start();
    }
}

void GamepadController::handleReadyRead()
{
    if (fd_ < 0) {
        return;
    }

    while (true) {
        js_event event{};
        const ssize_t bytesRead = ::read(fd_, &event, sizeof(event));

        if (bytesRead == static_cast<ssize_t>(sizeof(event))) {
            if ((event.type & JS_EVENT_INIT) != 0) {
                continue;
            }
            const unsigned int cleanType = static_cast<unsigned int>(event.type & ~JS_EVENT_INIT);
            handleJsEvent(cleanType, event.number, event.value);
            continue;
        }

        if (bytesRead < 0 && (errno == EAGAIN || errno == EWOULDBLOCK)) {
            break;
        }

        disconnectDevice();
        return;
    }
}

void GamepadController::handleJsEvent(unsigned int type, unsigned int number, int value)
{
    if (type == JS_EVENT_BUTTON) {
        const bool isPressed = (value != 0);

        // Standardowy uklad Xbox 360 pod Linuxem (xpad / joydev)
        switch (number) {
        case 0: processButtonState(Button::A, isPressed); break;
        case 1: processButtonState(Button::B, isPressed); break;
        case 2: processButtonState(Button::X, isPressed); break;
        case 3: processButtonState(Button::Y, isPressed); break;
        case 4: processButtonState(Button::L1, isPressed); break;
        case 5: processButtonState(Button::R1, isPressed); break;
        case 6: processButtonState(Button::Back, isPressed); break;
        case 7: processButtonState(Button::Start, isPressed); break;
        case 8: processButtonState(Button::Guide, isPressed); break;
        case 9: processButtonState(Button::L3, isPressed); break;
        case 10: processButtonState(Button::R3, isPressed); break;
        default:
            qDebug() << "[Gamepad] Unmapped raw button index:" << number << "value:" << value;
            break;
        }
        return;
    }

    if (type == JS_EVENT_AXIS) {
        switch (number) {
        case 0:  // Lewa galka X
            updateStickAxis(Stick::LeftStick, true, value);
            break;
        case 1:  // Lewa galka Y
            updateStickAxis(Stick::LeftStick, false, value);
            break;
        case 2:  // Spust L2 (-32767..32767)
            processButtonState(Button::L2, value > kAxisButtonThreshold);
            break;
        case 3:  // Prawa galka X
            updateStickAxis(Stick::RightStick, true, value);
            break;
        case 4:  // Prawa galka Y
            updateStickAxis(Stick::RightStick, false, value);
            break;
        case 5:  // Spust R2 (-32767..32767)
            processButtonState(Button::R2, value > kAxisButtonThreshold);
            break;
        case 6:  // D-Pad poziomo
            processButtonState(Button::DpadLeft, value < -kAxisButtonThreshold);
            processButtonState(Button::DpadRight, value > kAxisButtonThreshold);
            break;
        case 7:  // D-Pad pionowo
            processButtonState(Button::DpadUp, value < -kAxisButtonThreshold);
            processButtonState(Button::DpadDown, value > kAxisButtonThreshold);
            break;
        default:
            break;
        }
    }
}

void GamepadController::updateStickAxis(Stick stick, bool isXAxis, int rawValue)
{
    double& xRef = (stick == Stick::LeftStick) ? leftStickX_ : rightStickX_;
    double& yRef = (stick == Stick::LeftStick) ? leftStickY_ : rightStickY_;
    double& targetAxis = isXAxis ? xRef : yRef;

    const double normalized = normalizeAxis(rawValue);

    // Ignorujemy drobny szum, ale zawsze przepuszczamy powrot do dokladnego 0.0
    if (std::abs(normalized - targetAxis) < kStickChangeEpsilon &&
        (normalized != 0.0 || targetAxis == 0.0)) {
        return;
    }

    targetAxis = normalized;

    if (stick == Stick::LeftStick) {
        emit leftStickChanged(xRef, yRef);
    } else {
        emit rightStickChanged(xRef, yRef);
    }

    triggerMappedAxisAction(stick, xRef, yRef);
}

void GamepadController::processButtonState(Button button, bool isPressed)
{
    ButtonState& state = buttonStates_[button];

    if (isPressed && !state.pressed) {
        state.pressed = true;
        state.holdTriggered = false;
        state.pressTimer.start();
    } else if (!isPressed && state.pressed) {
        const bool wasHeld = state.holdTriggered;
        state.pressed = false;
        state.holdTriggered = false;

        const QString name = buttonToString(button);
        emit buttonReleased(button, name);

        if (!wasHeld) {
            qDebug() << "[Gamepad] Click:" << name;
            emit buttonClicked(button, name);
            triggerMappedAction(button, PressType::SingleClick);
        }
    }
}

void GamepadController::checkHoldStates()
{
    std::vector<Button> newlyHeld;

    for (auto& [button, state] : buttonStates_) {
        if (state.pressed && !state.holdTriggered &&
            state.pressTimer.elapsed() >= holdThresholdMs_) {
            state.holdTriggered = true;
            newlyHeld.push_back(button);
        }
    }

    for (const Button button : newlyHeld) {
        const QString name = buttonToString(button);
        qDebug() << "[Gamepad] Hold:" << name;
        emit buttonHeld(button, name);
        triggerMappedAction(button, PressType::Hold);
    }
}

void GamepadController::triggerMappedAction(Button button, PressType pressType)
{
    const auto mapIt = actionMap_.find({button, pressType});
    if (mapIt == actionMap_.end() || mapIt->second == Action::None) {
        return;
    }

    const Action action = mapIt->second;
    const QString name = actionToString(action);
    qDebug() << "[Gamepad] Action triggered:" << name;

    emit actionTriggered(action, name);

    const auto handlerIt = actionHandlers_.find(action);
    if (handlerIt != actionHandlers_.end() && handlerIt->second) {
        handlerIt->second();
    }
}

void GamepadController::triggerMappedAxisAction(Stick stick, double x, double y)
{
    const auto mapIt = axisActionMap_.find(stick);
    if (mapIt == axisActionMap_.end() || mapIt->second == AxisAction::None) {
        return;
    }

    const AxisAction action = mapIt->second;
    const QString name = axisActionToString(action);
    qDebug() << "[Gamepad] Axis action:" << name << "x:" << x << "y:" << y;

    emit axisActionTriggered(action, name, x, y);

    const auto handlerIt = axisActionHandlers_.find(action);
    if (handlerIt != axisActionHandlers_.end() && handlerIt->second) {
        handlerIt->second(x, y);
    }
}

double GamepadController::normalizeAxis(int rawValue) const
{
    double normalized = static_cast<double>(rawValue) / 32767.0;
    if (normalized < -1.0) {
        normalized = -1.0;
    } else if (normalized > 1.0) {
        normalized = 1.0;
    }
    if (std::abs(normalized) < deadzone_) {
        return 0.0;
    }
    return normalized;
}

void GamepadController::setConnected(bool connected)
{
    if (connected_ == connected) {
        return;
    }

    connected_ = connected;
    emit connectedChanged(connected_);
}

void GamepadController::setDeviceName(const QString& name)
{
    if (deviceName_ == name) {
        return;
    }

    deviceName_ = name;
    emit deviceNameChanged(deviceName_);
}

}  // namespace backend