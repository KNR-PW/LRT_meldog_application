import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: root

    anchors.fill: parent

    property color bgTop:    "#1a1d24"
    property color bgBottom: "#0f1115"

    RadialGradient {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: root.bgTop }
            GradientStop { position: 1.0; color: root.bgBottom }
        }
    }
    
    default property alias content: contentItem.data

    Item {
        id: contentItem
        anchors.fill:parent
    }
}
