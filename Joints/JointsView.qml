import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property real px: 1.0
    property string selectedLeg: "leg_lf"

    property bool jointsPanelOpen: false
    property string jointsLegId: ""

    property var legToJoints: ({
        "leg_lf": ["LFH_joint", "LFK_joint", "LFT_joint"],
        "leg_rf": ["RFH_joint", "RFK_joint", "RFT_joint"],
        "leg_lr": ["LRH_joint", "LRK_joint", "LRT_joint"],
        "leg_rr": ["RRH_joint", "RRK_joint", "RRT_joint"]
    })

    function openJointsPanel(legId) {
        root.jointsLegId = legId
        root.jointsPanelOpen = true
    }

    function closeJointsPanel() {
        root.jointsPanelOpen = false
        root.jointsLegId = ""
    }

    Card {
        id: mainCard
        px: root.px
        clip: true

        anchors.fill: parent
        anchors.leftMargin: 300 * px
        anchors.rightMargin: 300 * px
        anchors.topMargin: 80 * px
        anchors.bottomMargin: 160 * px

        Item {
            anchors.fill: parent
            anchors.margins: 20 * px

            RowLayout {
                anchors.fill: parent
                spacing: 16 * px
                visible: !root.jointsPanelOpen

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

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 6 * px

                                Text {
                                    text: "Selected leg:"
                                    color: "#E6EAF2"
                                    font.pixelSize: 26 * px
                                    font.bold: true
                                }

                                Text {
                                    text: root.selectedLeg
                                    color: "#2c9bd6"           
                                    font.pixelSize: 26 * px
                                    font.bold: true
                                }
                            }

                            Rectangle {
                                height: 1
                                color: "#2AFFFFFF"
                                Layout.fillWidth: true
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 34 * root.px
                                spacing: 16 * root.px

                                KeyBadge {
                                    id: badgeA
                                    px: root.px
                                    text: "A"
                                    variant: "success"
                                }

                                Text {
                                    text: "Select Joint"
                                    color: "#B3BAC4"
                                    font.pixelSize: 20 * root.px
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    horizontalAlignment: Text.AlignRight
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 34 * root.px
                                spacing: 16 * root.px

                                KeyBadge {
                                    px: root.px
                                    text: "R1 / R2"
                                    variant: "normal"
                                }

                                Text {
                                    text: "Switch Joint"
                                    color: "#B3BAC4"
                                    font.pixelSize: 20 * root.px
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    horizontalAlignment: Text.AlignRight
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            Rectangle {
                                height: 1
                                color: "#2AFFFFFF"
                                Layout.fillWidth: true
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                GridLayout {
                                    id: legGrid
                                    anchors.centerIn: parent   
                                    columns: 1
                                    columnSpacing: 20 * px
                                    rowSpacing: 20 * px

                                    property var legs: [
                                        { id: "leg_lf", label: "LF", subtitle: "Left Front"  },
                                        { id: "leg_rf", label: "RF", subtitle: "Right Front" },
                                        { id: "leg_lr", label: "LR", subtitle: "Left Rear"   },
                                        { id: "leg_rr", label: "RR", subtitle: "Right Rear"  }
                                    ]

                                    Repeater {
                                        model: legGrid.legs

                                        delegate: Rectangle {
                                            Layout.preferredWidth: 245 * px
                                            Layout.preferredHeight: 135 * px
                                            radius: 14 * px

                                            readonly property bool active: (modelData.id === root.selectedLeg)

                                            color: active ? "#FF9D00" : "#666666"
                                            border.width: 2 * px
                                            border.color: active ? "#FFD29A" : Qt.rgba(1, 1, 1, 0.10)

                                            Behavior on color { ColorAnimation { duration: 160 } }
                                            Behavior on border.color { ColorAnimation { duration: 160 } }

                                            Column {
                                                anchors.centerIn: parent
                                                spacing: 6 * px

                                                Text {
                                                    text: modelData.label
                                                    font.pixelSize: 32 * px
                                                    font.bold: true
                                                    color: active ? "#0B0F14" : "#E6EAF2"
                                                    horizontalAlignment: Text.AlignHCenter
                                                    width: parent ? parent.width : undefined
                                                }

                                                Text {
                                                    text: modelData.subtitle
                                                    font.pixelSize: 22 * px
                                                    color: active ? Qt.rgba(11/255, 15/255, 20/255, 0.75) : Qt.rgba(230/255, 234/255, 242/255, 0.70)
                                                    horizontalAlignment: Text.AlignHCenter
                                                    width: 130 * px
                                                    wrapMode: Text.WordWrap
                                                }
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                acceptedButtons: Qt.LeftButton | Qt.RightButton

                                                onClicked: (mouse) => {
                                                    root.selectedLeg = modelData.id

                                                    if (mouse.button === Qt.RightButton) {
                                                        root.openJointsPanel(modelData.id)
                                                    }
                                                }
                                            }
                                        }
                                    }
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

            MeldogJointsView {
                anchors.fill: parent
                visible: root.jointsPanelOpen

                px: root.px
                legId: root.jointsLegId
                jointNames: root.legToJoints[root.jointsLegId] || []

                onBackRequested: root.closeJointsPanel()
            }
        }
    }
}
