import QtQuick 2.15

Rectangle {
    id: root
    property real px: 1.0

    property var tabs: ["GAMEPAD CONTROLS", "SYSTEM MODULES", "DOCS & COMM"]
    property int currentIndex: 0
    signal tabChanged(int index)

    property real barHeight: 68 * px
    height: barHeight
    width: implicitWidth
    radius: 6 * px

    color: Qt.rgba(1, 1, 1, 0.03)                
    border.color: Qt.rgba(1, 1, 1, 0.08)
    border.width: 1

    property color accent: "#FF9D00"              
    property color textInactive: "#666666"
    property color textActive: "#000000"
    property color textHover: "#FFFFFF"

    property real padX: 9 * px
    property real padY: 9 * px

    implicitWidth: row.implicitWidth + padX * 2

    Row {
        id: row
        anchors.left: parent.left
        anchors.leftMargin: root.padX
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6 * px

        Repeater {
            model: root.tabs

            delegate: Item {
                id: cell
                property bool selected: (model.index === root.currentIndex)
                property bool hovered: false

                height: root.height - root.padY * 2
                width: Math.max(190 * root.px, label.implicitWidth + 26 * root.px)

                Rectangle {
                    id: pill
                    anchors.fill: parent
                    radius: 10 * px
                    color: cell.selected ? root.accent : "transparent"
                    border.width: 0
                }

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: modelData
                    font.bold: true
                    font.pixelSize: 20 * root.px

                    color: cell.selected ? root.textActive
                                         : (cell.hovered ? root.textHover : root.textInactive)

                    opacity: cell.selected ? 1.0 : (cell.hovered ? 0.95 : 0.85)
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: cell.hovered = true
                    onExited: cell.hovered = false

                    onClicked: {
                        if (root.currentIndex !== model.index) {
                            root.currentIndex = model.index
                            root.tabChanged(model.index)
                        }
                    }
                }
            }
        }
    }
}
