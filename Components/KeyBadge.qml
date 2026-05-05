import QtQuick 2.15

Rectangle {
    id: root

    property real px: 1.0
    property string text: "KEY"
    property string variant: "normal" // normal | success | danger | warning

    radius: 6 * px
    height: 34 * px  
    width: Math.max(94 * px, label.implicitWidth + 22 * px) 

    color: "#1F2329"
    border.width: 1
    border.color: "#3A404A"

    function applyVariant() {
        if (variant === "success") { label.color = "#00ff9d"; border.color = "#00ff9d" }
        else if (variant === "danger") { label.color = "#ff0055"; border.color = "#ff0055" }
        else if (variant === "warning") { label.color = "#ff9d00"; border.color = "#ff9d00" }
        else { label.color = "#E6EAF2"; border.color = "#3A404A" }
    }

    onVariantChanged: applyVariant()
    Component.onCompleted: applyVariant()

    Text {
        id: label
        anchors.centerIn: parent
        text: root.text
        font.pixelSize: 15 * px  
        font.family: "Monospace"
        font.bold: true
        opacity: 0.98
    }
}
