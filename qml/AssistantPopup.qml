import QtQuick 2.15

Item {
    id: popup

    property real px: 1
    property bool open: false

    width: 260 * px
    height: 140 * px

    opacity: 0.0
    scale: 0.98
    y: 8 * px
    visible: opacity > 0.01

    Rectangle {
        anchors.fill: parent
        radius: 12 * px
        color: "#0F1620"
        border.color: "#1f2a37"
        border.width: 1

        Text {
            anchors.centerIn: parent
            text: "Assistant popup"
            color: "#E6EAF2"
            font.pixelSize: 13 * px
        }
    }

    states: [
        State {
            name: "open"
            when: popup.open
            PropertyChanges { target: popup; opacity: 1.0; scale: 1.0; y: 0 }
        },
        State {
            name: "closed"
            when: !popup.open
            PropertyChanges { target: popup; opacity: 0.0; scale: 0.98; y: 8 * px }
        }
    ]

    transitions: [
        Transition {
            from: "closed"; to: "open"
            NumberAnimation { properties: "opacity,scale,y"; duration: 180; easing.type: Easing.OutCubic }
        },
        Transition {
            from: "open"; to: "closed"
            NumberAnimation { properties: "opacity,scale,y"; duration: 140; easing.type: Easing.InCubic }
        }
    ]
}
