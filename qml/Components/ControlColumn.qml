import QtQuick 2.15
import "qrc:/Components"

Item {
    id: root
    property real px: 1.0
    property string title: "TITLE"
    property color accentColor: "#00f0ff"
    property var rows: []

    width: 240 * px
    height: 420 * px

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: 10 * px
        color: Qt.rgba(1, 1, 1, 0.02)
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.05)
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 6 * px
        color: bg.color
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 4 * px
        color: root.accentColor
    }

    Item {
        id: content
        anchors.fill: parent
        anchors.leftMargin: 22 * px
        anchors.rightMargin: 16 * px
        anchors.topMargin: 14 * px
        anchors.bottomMargin: 18 * px

        Text {
            id: header
            text: root.title
            color: "#8A8F98"
            font.bold: true
            font.pixelSize: 20 * px   
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            anchors.topMargin: 12 * px
            height: 1 * px
            color: Qt.rgba(1,1,1,0.05)
        }

        Column {
            id: list
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom
            anchors.topMargin: 24 * px
            spacing: 16 * px  

            Repeater {
                model: root.rows
                delegate: Item {
                    width: list.width
                    height: 34 * root.px 

                    Row {
                        id: row
                        anchors.fill: parent
                        spacing: 16 * root.px

                        KeyBadge {
                            id: badge
                            px: root.px
                            text: modelData.key
                            variant: modelData.variant ? modelData.variant : "normal"
                        }

                        Text {
                            text: modelData.action
                            color: "#B3BAC4"
                            font.pixelSize: 18 * root.px   
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignRight
                            elide: Text.ElideRight
                            width: row.width - badge.width - row.spacing
                        }
                    }
                }
            }
        }
    }
}
