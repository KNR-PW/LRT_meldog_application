import QtQuick 2.15
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property real px: 1.0
    property int modeIndex: 0

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

        HomeHeader {
            id: homeheader
            px: root.px
            width: parent.width
            title: "MELDOG"
            subtitle: "OPERATOR CONTROL INTERFACE"
            logoSource: "qrc:/Assets/logo.png"
        }

        ModeTabs {
            id: modeTabs
            px: root.px
            anchors.left: parent.left
            anchors.leftMargin: 24 * root.px
            anchors.top: homeheader.bottom
            anchors.topMargin: 16 * root.px

            currentIndex: root.modeIndex
            onTabChanged: (index) => { root.modeIndex = index }
        }

        GamepadControlsPanel {
            px: root.px
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: modeTabs.bottom
            anchors.topMargin: 10 * root.px
            anchors.bottomMargin: 72 * root.px
            anchors.bottom: parent.bottom

            visible: root.modeIndex === 0
            enabled: visible
        }

        DocsAndCommPanel {
            px: root.px
            anchors.left: modeTabs.left
            anchors.right: modeTabs.right
            anchors.top: modeTabs.bottom
            anchors.topMargin: 28 * px

            visible: root.modeIndex === 2
            enabled: visible
        }
    }

    Connections {
        target: gamepadController

        function onActionTriggered(action, actionName) {
            if (!root.visible) {
                return
            }

            if (actionName === "SwitchSubpageNext") {
                root.modeIndex = (root.modeIndex + 1) % 3
                modeTabs.currentIndex = root.modeIndex
            } else if (actionName === "SwitchSubpagePrev") {
                root.modeIndex = (root.modeIndex + 2) % 3
                modeTabs.currentIndex = root.modeIndex
            }
        }
    }
}