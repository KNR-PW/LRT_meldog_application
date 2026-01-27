import QtQuick 2.0

Rectangle {
    id: root

    anchors.fill: parent

    property color bgTop:    "#0F141B"
    property color bgBottom: "#0B0F14"

    gradient: Gradient {
        GradientStop { position: 0.0; color: root.bgTop }
        GradientStop { position: 1.0; color: root.bgBottom }
    }

    default property alias content: contentItem.data

    Item {
        id: contentItem
        anchors.fill:parent
    }
}
