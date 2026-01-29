import QtQuick 2.15
import "qrc:/Components"

Item {
    id: root
    property real px: 1.0

    property var columns: [
        {
            title: "NAVIGATION",
            accent: "#00f0ff",
            rows: [
                { key: "L1 / R1", action: "Switch Page", variant: "normal" }
            ]
        },
        {
            title: "DASHBOARD",
            accent: "#3b82f6",     
            rows: [
                { key: "L2 / R2", action: "Switch Subpage", variant: "normal" }
            ]
        },
        {
            title: "RVIZ",
            accent: "#00ff9d",
            rows: [
                { key: "R-STICK", action: "Orbit / Rotate", variant: "normal" },
                { key: "L-STICK", action: "Pan", variant: "normal" },
                { key: "D-PAD", action: "Focus / Presets", variant: "normal" }
            ]
        },
        {
            title: "JOINTS",
            accent: "#ff0055",
            rows: [
                { key: "D-PAD \u2190\u2192", action: "Select Joint", variant: "normal" },
                { key: "D-PAD \u2191\u2193", action: "Move Joint", variant: "normal" },
                { key: "A", action: "Do Meldog Flip", variant: "success" },
                { key: "B", action: "Start Position", variant: "danger" },
                { key: "Y", action: "Reset Position", variant: "warning" }
            ]
        }
    ]

    readonly property int colCount: columns.length
    readonly property real outerPadding: 32 * px
    readonly property real gap: 36 * px

    readonly property real availableWidth: Math.max(0, width - 2 * outerPadding - gap * (colCount - 1))
    readonly property real colWidth: Math.max(0, availableWidth / Math.max(1, colCount))

    Grid {
        anchors.fill: parent
        anchors.leftMargin: root.outerPadding
        anchors.rightMargin: root.outerPadding
        anchors.topMargin: root.outerPadding
        anchors.bottomMargin: root.outerPadding

        columns: root.colCount
        columnSpacing: root.gap
        rowSpacing: root.gap

        Repeater {
            model: root.columns
            delegate: ControlColumn {
                px: root.px
                width: root.colWidth
                height: root.height
                title: modelData.title
                accentColor: modelData.accent
                rows: modelData.rows
            }
        }
    }
}
