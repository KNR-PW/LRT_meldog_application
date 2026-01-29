import QtQuick 2.0
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property real px: 1.0

    Card {
        id: mainCard 
        px: root.px 
        clip: true

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        anchors.leftMargin: 300 * px
        anchors.rightMargin: 300 * px
        anchors.topMargin: 80 * px
        anchors.bottomMargin: 160 * px

        Text {
            anchors.centerIn: parent
            text: "JointsView (placeholder)"
            color: "#E6EAF2"
            font.pixelSize: 22
        }
    }
}
