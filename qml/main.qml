import QtQuick 2.15

import "Components"
import "Home"

BackgroundRoot {
    id: root
    
    readonly property real px: Math.max(0.8, Math.min(width, height) / 1200.0)
    property int toolbarIndex: 0
    
    MainToolBar {
        id: mainToolbar
        px: root.px 
        toolbarHeight: 92 * px   
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

        }
    }
}
