import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property real px: 1.0

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

        Column {
            anchors.centerIn: parent
            width: Math.min(parent.width * 0.75, 640 * px)
            spacing: 20 * px

            Text {
                width: parent.width
                text: "RVIZ"
                color: "#E6EAF2"
                font.pixelSize: 45 * px
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                width: parent.width
                text: "This tab launches RViz in a separate window using meldog_rviz.launch.xml."
                color: "#B3BAC4"
                font.pixelSize: 25 * px
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                width: parent.width
                text: appController.rvizStatus
                color: appController.rvizRunning ? "#00D084" : "#E6EAF2"
                font.pixelSize: 24 * px
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20 * px

                Button {
                    id: launchButton
                    width: 220 * px
                    height: 64 * px
                    enabled: !appController.rvizRunning
                    onClicked: appController.launchRviz()

                    contentItem: Text {
                        text: "Launch RViz"
                        color: launchButton.enabled ? "#0B0F14" : "#6E7684"
                        font.pixelSize: 22 * px
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        radius: 14 * px
                        color: launchButton.enabled ? "#FF9D00" : "#4A4F57"
                        border.width: 2
                        border.color: launchButton.enabled ? "#FFD29A" : "#666A73"
                    }
                }

                Button {
                    id: stopButton
                    width: 220 * px
                    height: 64 * px
                    enabled: appController.rvizRunning
                    onClicked: appController.stopRviz()

                    contentItem: Text {
                        text: "Stop RViz"
                        color: stopButton.enabled ? "#E6EAF2" : "#6E7684"
                        font.pixelSize: 22 * px
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        radius: 14 * px
                        color: stopButton.enabled ? "#D64545" : "#4A4F57"
                        border.width: 2
                        border.color: stopButton.enabled ? "#FF9A9A" : "#666A73"
                    }
                }
            }
        }
    }
}