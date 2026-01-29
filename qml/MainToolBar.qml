import QtQuick 2.15
import "Components"

Rectangle {
    id: root

    property real px: 1.0

    property real toolbarHeight: 80 * px
    height: toolbarHeight

    property int toolbarIndex: 0

    property var tabs: [
        { label: "DASHBOARD" },
        { label: "RVIZ" },
        { label: "JOINTS" }
    ]

    readonly property int itemCount: tabs.length
    readonly property real itemWidth: toolbarItemsArea.width / Math.max(1, itemCount)
    readonly property real tabHeight: Math.max(30 * px, height * 0.58)

    border.color: "#1f2a37"
    border.width: 1

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#141C26" }
        GradientStop { position: 1.0; color: "#0F1620" }
    }

    Item {
        id: toolbarItemsArea
        anchors.left: parent.left
        anchors.right: assistantButton.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 16 * px
        anchors.rightMargin: 12 * px

        Row {
            id: tabsRow
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            Repeater {
                model: root.tabs
                delegate: Item {
                    width: root.itemWidth
                    height: root.tabHeight

                    TabBarItem {
                        anchors.centerIn: parent
                        px: root.px
                        index: model.index
                        text: modelData.label
                        height: parent.height
                        selected: root.toolbarIndex === model.index

                        onClicked: function(i) { root.toolbarIndex = i }
                    }
                }
            }
        }
    }

    Rectangle {
        id: assistantButton
        width: Math.max(40 * px, height * 0.55)
        height: width
        radius: 12 * px
        anchors.right: parent.right
        anchors.rightMargin: 14 * px
        anchors.verticalCenter: parent.verticalCenter
        color: "#0F1620"
        border.color: "#1f2a37"
        border.width: 1

        Text {
            anchors.centerIn: parent
            text: "?"
            color: "#E6EAF2"
            font.pixelSize: Math.max(14 * px, parent.height * 0.45)
            font.bold: true
        }
    }
}
