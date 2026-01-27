import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root

    property real px: 1

    height: 60 * px
    width: parent ? parent.width : 0

    color: "#111822"

    gradient: Gradient {
        GradientStop { position: 0.0; color: '#223246' }
        GradientStop { position: 1.0; color: "#0F1620" }
    }
}
