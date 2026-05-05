import QtQuick 2.15

import "Components"
import "Home"
import "Rviz"
import "Joints"

BackgroundRoot {
    id: root
    
    readonly property real px: Math.max(0.8, Math.min(width, height) / 1200.0)
    
    readonly property real cardWidth: Math.max(0, Math.min(mainViewContainer.width * 0.90, 1200 * px))
    readonly property real cardHeight: Math.max(0, mainViewContainer.height * 0.85)
    readonly property real cardTopGap: 24 * px
    
    MainToolBar {
        id: mainToolBar
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
        anchors.top: mainToolBar.bottom
        anchors.bottom: parent.bottom

        HomeView {
            px: root.px
            visible: mainToolBar.toolbarIndex == 0
            enabled: visible
        }

        RvizView {
            px: root.px
            visible: mainToolBar.toolbarIndex === 1
            enabled: visible
        }

        JointsView {
            px: root.px
            visible: mainToolBar.toolbarIndex === 2
            enabled: visible
        }
    }
}
