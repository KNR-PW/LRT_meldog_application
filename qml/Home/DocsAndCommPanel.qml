import QtQuick 2.15
import "qrc:/Components"

Item {
    id: root
    property real px: 1.0
    property string repoURL: "https://github.com/tpiwonski99"

    Item {
        id: repoSection

        height: ctaColumn.implicitHeight

        Column {
            id: ctaColumn
            spacing: 12 * px
            anchors.left: parent.left
            anchors.right: parent.right

            Text {
                text: "For detailed API reference check out Meldog repository."
                color: '#f4f6f8'
                font.pixelSize: 22 * px
                wrapMode: Text.WordWrap
            }

            Rectangle {
                id: repoButton
                height: 42 * px
                width: 200 * px
                radius: 6 * px
                color: "transparent"
                border.width: 1
                border.color: "#ff9d00"

                Text {
                    anchors.centerIn: parent
                    text: "OPEN REPOSITORY →"
                    color: "#ff9d00"
                    font.pixelSize: 15 * px
                    font.bold: true
                    font.letterSpacing: 1.2
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Qt.openUrlExternally(root.repoURL)
                    onPressed: repoButton.opacity = 0.75
                    onReleased: repoButton.opacity = 1.0
                    onCanceled: repoButton.opacity = 1.0
                }
            }
        }
    }
}