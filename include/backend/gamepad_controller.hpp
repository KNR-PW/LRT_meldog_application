#pragma once

#include <QElapsedTimer>
#include <QObject>
#include <QSocketNotifier>
#include <QString>
#include <QTimer>

#include <functional>
#include <map>
#include <utility>

namespace backend {

class GamepadController final : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(QString deviceName READ deviceName NOTIFY deviceNameChanged)
    Q_PROPERTY(int holdThresholdMs READ holdThresholdMs WRITE setHoldThresholdMs NOTIFY holdThresholdMsChanged)

public:
    enum class Button {
        A,
        B,
        X,
        Y,
        L1,
        R1,
        L2,
        R2,
        Back,
        Start,
        Guide,
        L3,
        R3,
        DpadUp,
        DpadDown,
        DpadLeft,
        DpadRight
    };
    Q_ENUM(Button)

    enum class Stick {
        LeftStick,
        RightStick
    };
    Q_ENUM(Stick)

    enum class PressType {
        SingleClick,
        Hold
    };
    Q_ENUM(PressType)

    enum class Action {
        None,
        SwitchPagePrev,
        SwitchPageNext,
        SwitchSubpagePrev,
        SwitchSubpageNext,
        SelectJointPrev,
        SelectJointNext,
        MoveJointUp,
        MoveJointDown,
        DoMeldogFlip,
        StartPosition,
        ResetPosition,
        FocusPreset,
        EmergencyStop
    };
    Q_ENUM(Action)

    enum class AxisAction {
        None,
        RvizOrbitRotate,
        RvizPan
    };
    Q_ENUM(AxisAction)

    explicit GamepadController(QObject* parent = nullptr);
    ~GamepadController() override;

    bool connected() const;
    QString deviceName() const;
    int holdThresholdMs() const;
    void setHoldThresholdMs(int thresholdMs);

    void mapButton(Button button, PressType pressType, Action action);
    void clearMapping(Button button, PressType pressType);
    void registerActionHandler(Action action, std::function<void()> callback);

    void mapStick(Stick stick, AxisAction action);
    void clearStickMapping(Stick stick);
    void registerAxisActionHandler(AxisAction action, std::function<void(double, double)> callback);

    Q_INVOKABLE QString buttonToString(Button button) const;
    Q_INVOKABLE QString actionToString(Action action) const;
    Q_INVOKABLE QString axisActionToString(AxisAction action) const;

signals:
    void connectedChanged(bool connected);
    void deviceNameChanged(const QString& deviceName);
    void holdThresholdMsChanged(int thresholdMs);

    void buttonClicked(backend::GamepadController::Button button, const QString& buttonName);
    void buttonHeld(backend::GamepadController::Button button, const QString& buttonName);
    void buttonReleased(backend::GamepadController::Button button, const QString& buttonName);

    void actionTriggered(backend::GamepadController::Action action, const QString& actionName);
    void axisActionTriggered(backend::GamepadController::AxisAction action,
                             const QString& actionName,
                             double x,
                             double y);

    void leftStickChanged(double x, double y);
    void rightStickChanged(double x, double y);

private slots:
    void tryConnect();
    void handleReadyRead();
    void checkHoldStates();

private:
    struct ButtonState {
        bool pressed = false;
        bool holdTriggered = false;
        QElapsedTimer pressTimer;
    };

    void loadDefaultMappings();
    void disconnectDevice();
    void handleJsEvent(unsigned int type, unsigned int number, int value);
    void processButtonState(Button button, bool isPressed);
    void updateStickAxis(Stick stick, bool isXAxis, int rawValue);
    void triggerMappedAction(Button button, PressType pressType);
    void triggerMappedAxisAction(Stick stick, double x, double y);
    double normalizeAxis(int rawValue) const;

    void setConnected(bool connected);
    void setDeviceName(const QString& name);

    int fd_ = -1;
    bool connected_ = false;
    QString deviceName_;
    int holdThresholdMs_ = 500;
    double deadzone_ = 0.20;

    QSocketNotifier* socketNotifier_ = nullptr;
    QTimer* reconnectTimer_ = nullptr;
    QTimer* holdCheckTimer_ = nullptr;

    double leftStickX_ = 0.0;
    double leftStickY_ = 0.0;
    double rightStickX_ = 0.0;
    double rightStickY_ = 0.0;

    std::map<Button, ButtonState> buttonStates_;
    std::map<std::pair<Button, PressType>, Action> actionMap_;
    std::map<Action, std::function<void()>> actionHandlers_;

    std::map<Stick, AxisAction> axisActionMap_;
    std::map<AxisAction, std::function<void(double, double)>> axisActionHandlers_;
};

}  // namespace backend