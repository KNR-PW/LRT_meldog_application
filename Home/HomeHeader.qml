import QtQuick 2.15

Item {
    id: root

    property real px: 1.0
    clip: true

    property string title: "MELDOG"
    property string subtitle: "OPERATOR CONTROL INTERFACE"

    property real padV: 24 * px
    property real padH: 32 * px

    readonly property real titleSize: Math.max(20 * px, Math.min(40 * px, 32 * px))
    readonly property real subtitleSize: Math.max(11 * px, Math.min(18 * px, 14 * px))

    property url logoSource: ""
    property real logoHeight: Math.max(34 * px, Math.min(86 * px, 72 * px))

    width: parent ? parent.width : 800 * px
    implicitHeight: Math.max(logo.visible ? logo.height : 0, textBlock.implicitHeight) + 2 * padV
    height: implicitHeight

    

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1 * px
        color: "#0DFFFFFF" 
    }

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: padH
        anchors.rightMargin: padH
        anchors.topMargin: padV
        spacing: 24 * px

        Image {
            id: logo
            source: root.logoSource
            height: root.logoHeight
            width: height
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            visible: source !== ""
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            id: textBlock
            spacing: 3 * px
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - (logo.visible ? (logo.width + 24 * px) : 0)

            Text {
                text: root.title
                width: parent.width       
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
                color: "#FFFFFF"
                font.bold: true
                font.pixelSize: root.titleSize
            }

            Text {
                text: root.subtitle
                width: parent.width       
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
                color: "#FF9D00"
                opacity: 0.85
                font.pixelSize: root.subtitleSize
            }
        }
    }
}
