import QtQuick 2.15

Rectangle {
    property real px: 1.0
    color: "#202630"

    Text {
        anchors.centerIn: parent
        text: "MelDog Diagnostics"
        color: "white"
        font.pixelSize: 30 * px
    }
}