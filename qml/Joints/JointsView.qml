<<<<<<< HEAD
import QtQuick 2.0
=======
import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
>>>>>>> 5265032 (- full Meldog model added)
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property real px: 1.0
<<<<<<< HEAD

    Card {
        id: mainCard 
        px: root.px 
=======
    property string selectedLeg: "leg_lf"

    property var legToJoints: ({
        "leg_lf": ["LFH_joint", "LFK_joint", "LFT_joint"],
        "leg_rf": ["RFH_joint", "RFK_joint", "RFT_joint"],
        "leg_lr": ["LRH_joint", "LRK_joint", "LRT_joint"],
        "leg_rr": ["RRH_joint", "RRK_joint", "RRT_joint"]
    })

    Card {
        id: mainCard
        px: root.px
>>>>>>> 5265032 (- full Meldog model added)
        clip: true

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        anchors.leftMargin: 300 * px
        anchors.rightMargin: 300 * px
        anchors.topMargin: 80 * px
        anchors.bottomMargin: 160 * px

<<<<<<< HEAD
        Text {
            anchors.centerIn: parent
            text: "JointsView (placeholder)"
            color: "#E6EAF2"
            font.pixelSize: 22
=======
        Item {
            anchors.fill: parent
            anchors.margins: 20 * px

            RowLayout {
                anchors.fill: parent
                spacing: 16 * px

                Card {
                    px: root.px
                    Layout.preferredWidth: 360 * px
                    Layout.fillHeight: true

                    Item {
                        anchors.fill: parent
                        anchors.margins: 16 * px

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 12 * px

                            Text {
                                text: "Selected leg: " + root.selectedLeg
                                color: "#E6EAF2"
                                font.pixelSize: 18 * px
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                height: 1
                                color: "#2AFFFFFF"
                                Layout.fillWidth: true
                            }

                            ScrollView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true

                                ColumnLayout {
                                    width: parent.width
                                    spacing: 12 * px

                                    Repeater {
                                        model: root.legToJoints[root.selectedLeg] || []

                                        delegate: ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 6 * px

                                            Text {
                                                text: modelData
                                                color: "#C9D1E6"
                                                font.pixelSize: 14 * px
                                                Layout.fillWidth: true
                                            }

                                            Slider {
                                                from: -1.57
                                                to: 1.57
                                                value: 0
                                                Layout.fillWidth: true
                                            }
                                        }
                                    }

                                    Item { height: 8 * px }
                                }
                            }
                        }
                    }
                }

                Card {
                    px: root.px
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Item {
                        anchors.fill: parent
                        anchors.margins: 8 * px

                        MeldogView {
                            anchors.fill: parent
                            selectedLeg: root.selectedLeg
                            onLegSelected: (legId) => root.selectedLeg = legId
                        }
                    }
                }
            }
>>>>>>> 5265032 (- full Meldog model added)
        }
    }
}
