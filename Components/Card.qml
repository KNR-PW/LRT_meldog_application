import QtQuick 2.15

Item {
    id: root

    property real px: 1.0

    property real radius: 12 * px

    property color fillColor: "#D90D0F14"

    property color borderColor: "#1AFFFFFF"
    property real borderWidth: 1 * px

    property bool enableGlow: true
    property real glowOpacity: 0.22  

    default property alias content: contentItem.data

    Rectangle {
        id: panel
        anchors.fill: parent
        radius: root.radius
        color: root.fillColor
        border.color: root.borderColor
        border.width: root.borderWidth
        z: 1

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: parent.height * 0.42
            radius: root.radius
            visible: root.enableGlow
            opacity: root.enableGlow ? root.glowOpacity : 0.0

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#1400F0FF" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: root.radius
            color: "#000000"
            opacity: 0.06
        }

        Item {
            id: contentItem
            anchors.fill: parent
        }
    }
}
