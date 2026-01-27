import QtQuick 2.15

import "Components"
import "Home"

BackgroundRoot {
    id: root

    MainToolBar {
        id: mainToolbar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
    }

    Item {
        id: mainViewContainer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: mainToolbar.bottom
        anchors.bottom: parent.bottom

        HomeView {
            anchors.fill: parent
        }
    }
}
