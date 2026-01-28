import QtQuick 2.15

Item {
    id: root

    property real px: 1.0

    property int index: -1
    property bool selected: false

    property color accent: "#ff9d00"
    property color textColorOnAccent: "#0B0F14"
    property color textColorNormal: "#E6EAF2"
    property color textColorMuted: "#9AA4B2"

    property real fontSize: Math.max(10 * px, height * 0.42)
    property real hPad: Math.max(10 * px, height * 0.45)

    property string text: "TAB"

    signal clicked(int index)

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: accent
        opacity: root.selected ? 1.0 : 0.0

        Behavior on opacity {
            NumberAnimation { duration: 160; easing.type: Easing.InOutQuad }
        }
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: root.text
        font.pixelSize: root.fontSize
        font.bold: true
        color: root.selected ? root.textColorOnAccent : root.textColorMuted

        Behavior on color {
            ColorAnimation { duration: 160 }
        }
    }

    width: label.implicitWidth + 2 * root.hPad

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked(root.index)
    }
}
