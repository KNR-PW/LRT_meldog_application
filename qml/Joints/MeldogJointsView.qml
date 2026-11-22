import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    anchors.fill: parent

    property real px: 1.0
    property string legId: ""
    property var jointNames: []

    signal backRequested()

    readonly property color cText:   "#E6EAF2"
    readonly property color cMuted:  "#8B9BB4"
    readonly property color cPanel:  Qt.rgba(0,0,0,0.22)
    readonly property color cBorder: Qt.rgba(1,1,1,0.10)

    readonly property color cSuccess:"#00FF9D"
    readonly property color cDanger: "#FF0055"
    readonly property color cAccent: "#ff9d00"
    readonly property color cSlider: cAccent

    readonly property real rad2deg: 57.29577951308232
    readonly property real sliderMin: -1.57
    readonly property real sliderMax:  1.57
    readonly property real sliderSpeedRadPerSec: 1.6

    property var _values: ({})
    property int selectedJointIndex: 0
    property real stickY: 0.0

    function _initValues() {
        const o = {}
        for (let i = 0; i < jointNames.length; i++)
            o[jointNames[i]] = 0
        _values = o
        selectedJointIndex = 0
        stickY = 0.0
    }

    function resetAll() { _initValues() }

    function cycleSelectedJoint(step) {
        if (!jointNames || jointNames.length === 0)
            return
        selectedJointIndex = (selectedJointIndex + step + jointNames.length) % jointNames.length
    }

    function adjustSelectedJoint(deltaRad) {
        if (!jointNames || jointNames.length === 0)
            return
        const idx = Math.max(0, Math.min(selectedJointIndex, jointNames.length - 1))
        const jName = jointNames[idx]
        const current = _values[jName] ?? 0
        const next = Math.max(sliderMin, Math.min(sliderMax, current + deltaRad))

        if (Math.abs(next - current) < 0.0001)
            return

        const copy = Object.assign({}, _values)
        copy[jName] = next
        _values = copy
    }

    onJointNamesChanged: _initValues()
    onVisibleChanged: {
        if (!visible)
            stickY = 0.0
    }
    Component.onCompleted: _initValues()

    Timer {
        id: stickUpdateTimer
        interval: 20
        repeat: true
        running: root.visible && gamepadController.connected && Math.abs(root.stickY) > 0.001

        onTriggered: {
            // Na Linuxie pchniecie galki w gore daje ujemne Y, wiec odwracamy znak
            const delta = (-root.stickY) * root.sliderSpeedRadPerSec * (interval / 1000.0)
            root.adjustSelectedJoint(delta)
        }
    }

    Connections {
        target: gamepadController

        function onActionTriggered(action, actionName) {
            if (!root.visible)
                return

            if (actionName === "SelectJointPrev") {
                root.cycleSelectedJoint(-1)
            } else if (actionName === "SelectJointNext") {
                root.cycleSelectedJoint(1)
            } else if (actionName === "ResetPosition") {
                root.resetAll()
            }
        }

        function onLeftStickChanged(x, y) {
            if (!root.visible) {
                root.stickY = 0.0
                return
            }
            root.stickY = y
        }

        function onConnectedChanged(connected) {
            if (!connected)
                root.stickY = 0.0
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16 * px
        spacing: 18 * px

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 4
            spacing: 12 * px

            RowLayout {
                Layout.fillWidth: true
                spacing: 12 * px

                Rectangle {
                    radius: 6 * px
                    height: 45 * px
                    width: Math.max(220 * px, titleText.implicitWidth + 28 * px)
                    color: cAccent

                    Text {
                        id: titleText
                        anchors.centerIn: parent
                        text: legId !== "" ? (legId.toUpperCase() + "  •  JOINTS") : "JOINTS"
                        color: "#0B0F14"
                        font.pixelSize: 20 * px
                        font.bold: true
                    }
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    id: resetBtn
                    radius: 6 * px
                    height: 40 * px
                    width: 150 * px
                    color: Qt.rgba(0, 255/255, 157/255, 0.05)
                    border.width: 1
                    border.color: cSuccess

                    Text {
                        anchors.centerIn: parent
                        text: "↺  RESET"
                        color: cSuccess
                        font.pixelSize: 13 * px
                        font.bold: true
                        font.letterSpacing: 1.2
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: resetBtn.color = Qt.rgba(0, 255/255, 157/255, 0.12)
                        onExited:  resetBtn.color = Qt.rgba(0, 255/255, 157/255, 0.05)
                        onClicked: root.resetAll()
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 10 * px
                color: cPanel
                border.width: 1
                border.color: cBorder

                Item {
                    anchors.fill: parent
                    anchors.margins: 18 * px

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12 * px

                        Repeater {
                            model: root.jointNames

                            delegate: Rectangle {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                radius: 10 * px

                                readonly property string jName: modelData
                                readonly property bool selected: (index === root.selectedJointIndex)
                                property bool dragging: false
                                readonly property bool active: dragging || selected

                                color: selected ? Qt.rgba(255/255, 157/255, 0, 0.08) : "transparent"
                                border.width: selected ? 2 * px : 1
                                border.color: selected ? cAccent : "transparent"

                                Behavior on color { ColorAnimation { duration: 120 } }
                                Behavior on border.color { ColorAnimation { duration: 120 } }

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 10 * px
                                    spacing: 10 * px

                                    Text {
                                        width: parent.width
                                        text: jName
                                        color: active ? cText : cMuted
                                        font.pixelSize: 16 * px
                                        font.bold: active
                                        horizontalAlignment: Text.AlignHCenter
                                        elide: Text.ElideRight
                                    }

                                    Item {
                                        id: sliderBox
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: 52 * px
                                        height: parent.height - (72 * px)

                                        readonly property real vMin: root.sliderMin
                                        readonly property real vMax: root.sliderMax

                                        readonly property real v: root._values[jName] ?? 0

                                        function clamp(x, a, b) { return Math.max(a, Math.min(b, x)) }

                                        function yFromValue(val) {
                                            const yMax = Math.max(1, sliderBox.height - handle.height)
                                            const t = (clamp(val, vMin, vMax) - vMin) / (vMax - vMin)
                                            return (1.0 - t) * yMax
                                        }

                                        function valueFromY(y) {
                                            const yMax = Math.max(1, sliderBox.height - handle.height)
                                            const t = 1.0 - clamp(y, 0, yMax) / yMax
                                            return vMin + t * (vMax - vMin)
                                        }

                                        Rectangle {
                                            id: track
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: 8 * px
                                            height: parent.height
                                            radius: 3 * px
                                            color: selected ? Qt.rgba(255/255, 157/255, 0, 0.25) : Qt.rgba(1,1,1,0.10)
                                        }

                                        Rectangle {
                                            id: handle
                                            width: 32 * px
                                            height: 20 * px
                                            radius: 3 * px
                                            color: cSlider
                                            border.width: selected ? 2 : 1
                                            border.color: "#FFFFFF"

                                            x: (sliderBox.width - width) / 2

                                            Binding {
                                                target: handle
                                                property: "y"
                                                value: sliderBox.yFromValue(sliderBox.v)
                                                when: !dragArea.drag.active
                                            }

                                            MouseArea {
                                                id: dragArea
                                                anchors.fill: parent
                                                cursorShape: Qt.OpenHandCursor
                                                hoverEnabled: true

                                                drag.target: handle
                                                drag.axis: Drag.YAxis
                                                drag.minimumY: 0
                                                drag.maximumY: sliderBox.height - handle.height

                                                onPressed: {
                                                    cursorShape = Qt.ClosedHandCursor
                                                    root.selectedJointIndex = index
                                                    dragging = true
                                                }
                                                onReleased: {
                                                    cursorShape = Qt.OpenHandCursor
                                                    dragging = false
                                                }
                                                onCanceled: dragging = false

                                                onPositionChanged: {
                                                    dragging = true
                                                    const newVal = sliderBox.valueFromY(handle.y)
                                                    const copy = Object.assign({}, root._values)
                                                    copy[jName] = newVal
                                                    root._values = copy
                                                }
                                            }
                                        }
                                    }

                                    Column {
                                        width: parent.width
                                        spacing: 4 * px

                                        Text {
                                            width: parent.width
                                            text: Math.round(((root._values[jName] ?? 0) * root.rad2deg)) + "°"
                                            color: cText
                                            font.pixelSize: 13 * px
                                            font.bold: true
                                            horizontalAlignment: Text.AlignHCenter
                                        }

                                        Rectangle {
                                            width: Math.min(parent.width * 1.1, 140 * px)
                                            height: 2 * px
                                            radius: 1 * px
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            color: cSlider
                                            opacity: selected ? 1.0 : 0.45
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            clip: true
            Layout.fillHeight: true
            Layout.minimumWidth: 260 * px
            Layout.preferredWidth: 1
            radius: 10 * px
            color: cPanel
            border.width: 1
            border.color: cBorder

            Rectangle {
                id: statusBox
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 18 * px
                anchors.rightMargin: 18 * px
                anchors.bottomMargin: 18 * px

                height: 110 * px
                radius: 10 * px
                color: Qt.rgba(0,0,0,0.22)
                border.width: 1
                border.color: Qt.rgba(1,1,1,0.05)

                Column {
                    anchors.fill: parent
                    anchors.margins: 16 * px
                    spacing: 10 * px

                    Text {
                        width: parent.width
                        text: "STATUS:"
                        color: "#666666"
                        font.pixelSize: 16 * px
                        font.bold: true
                        font.letterSpacing: 2
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        width: parent.width
                        text: "STOPPED"
                        color: cMuted
                        font.pixelSize: 24 * px
                        font.bold: true
                        font.letterSpacing: 3
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            ColumnLayout {
                id: rightContent
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: statusBox.top
                anchors.margins: 18 * px
                spacing: 16 * px

                Text {
                    Layout.fillWidth: true
                    text: "JOINTS OPTIONS"
                    color: cDanger
                    font.pixelSize: 20 * px
                    font.bold: true
                    font.letterSpacing: 3
                    horizontalAlignment: Text.AlignHCenter
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12 * px

                    Rectangle {
                        id: btnOpen
                        Layout.fillWidth: true
                        height: 52 * px
                        radius: 8 * px
                        color: Qt.rgba(0, 255/255, 157/255, 0.05)
                        border.width: 2
                        border.color: cSuccess

                        Text {
                            anchors.centerIn: parent
                            text: "OPEN"
                            color: cSuccess
                            font.pixelSize: 17 * px
                            font.bold: true
                            font.letterSpacing: 2
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: btnOpen.color = Qt.rgba(0, 255/255, 157/255, 0.10)
                            onExited:  btnOpen.color = Qt.rgba(0, 255/255, 157/255, 0.05)
                            onClicked: {}
                        }
                    }

                    Rectangle {
                        id: btnStop
                        Layout.fillWidth: true
                        height: 52 * px
                        radius: 8 * px
                        color: Qt.rgba(1,1,1,0.03)
                        border.width: 2
                        border.color: cMuted

                        Text {
                            anchors.centerIn: parent
                            text: "STOP"
                            color: cText
                            font.pixelSize: 17 * px
                            font.bold: true
                            font.letterSpacing: 2
                            opacity: 0.9
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: btnStop.color = Qt.rgba(1,1,1,0.06)
                            onExited:  btnStop.color = Qt.rgba(1,1,1,0.03)
                            onClicked: {}
                        }
                    }

                    Rectangle {
                        id: btnClose
                        Layout.fillWidth: true
                        height: 52 * px
                        radius: 8 * px
                        color: Qt.rgba(255/255, 0, 85/255, 0.05)
                        border.width: 2
                        border.color: cDanger

                        Text {
                            anchors.centerIn: parent
                            text: "CLOSE"
                            color: cDanger
                            font.pixelSize: 17 * px
                            font.bold: true
                            font.letterSpacing: 2
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: btnClose.color = Qt.rgba(255/255, 0, 85/255, 0.10)
                            onExited:  btnClose.color = Qt.rgba(255/255, 0, 85/255, 0.05)
                            onClicked: root.backRequested()
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}