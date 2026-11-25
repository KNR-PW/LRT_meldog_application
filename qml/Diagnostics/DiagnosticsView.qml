import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    implicitWidth: 700
    implicitHeight: 450
    width: parent ? parent.width : implicitWidth
    height: parent ? parent.height : implicitHeight
    color: "#0F1620"
    clip: true

    // Keep text readable even in small windows; enlarge gently on wide screens.
    property real px: Math.max(1.0, Math.min(1.25, width / 1000))
    readonly property bool wideLayout: width >= 900 * px
    readonly property real outerMargin: 12 * px
    readonly property real panelPadding: 14 * px
    readonly property real panelGap: 10 * px
    readonly property real rowHeight: 48 * px
    readonly property real controlHeight: 44 * px
    readonly property real scrollGutter: 10 * px
    readonly property real usableWidth: Math.max(0, width - 2 * outerMargin - scrollGutter)
    readonly property real jointPanelWidth: wideLayout ? Math.max(0, (usableWidth - panelGap) * 0.40) : usableWidth
    readonly property real topicPanelWidth: wideLayout ? Math.max(0, usableWidth - panelGap - jointPanelWidth) : usableWidth
    readonly property bool stackedControls: topicPanelWidth < 290 * px

    // Same palette as the other MelDog views.
    readonly property color cText:   "#E6EAF2"
    readonly property color cMuted:  "#8B9BB4"
    readonly property color cPanel:  Qt.rgba(0,0,0,0.22)
    readonly property color cBorder: Qt.rgba(1,1,1,0.10)
    readonly property color cSuccess: "#00FF9D"
    readonly property color cDanger:  "#FF0055"
    readonly property color cAccent:  "#ff9d00"
    readonly property color rowColor: Qt.rgba(1,1,1,0.035)
    readonly property color alternateRowColor: Qt.rgba(1,1,1,0.015)

    ListModel {
        id: jointModel
    }

    ListModel {
        id: topicModel

        ListElement {
            topicName: "/joint_states"
            frequency: 0.0
        }

        ListElement {
            topicName: "/tf"
            frequency: 0.0
        }
    }

    Connections {
        target: diagnosticsBridge

        function onJointUpdated(name, position) {
            for(let i = 0; i < jointModel.count; i++){
                if(jointModel.get(i).jointName===name){
                    jointModel.setProperty(i, "jointPosition", position)
                    return;
                }
            }

            jointModel.append({jointName: name, jointPosition: position})
        }

        function onTopicFrequenciesUpdated(topics) {
            topicModel.clear()

            for (let top = 0; top < topics.length; top++) {
                topicModel.append({
                    topicName: topics[top].name,
                    "frequency": topics[top].frequency
                })
            }
        }
    }

    property bool gamepadConnected: false

    Connections {
        target: gamepadController

        function onConnectedChanged(connected) {
            gamepadConnected = connected
        }
    }

    Component.onCompleted: {
        updateSuggestions()
    }

    ListModel {
        id: suggestionModel
    }

    function updateSuggestions(){
        suggestionModel.clear()
        for (let avail = 0; avail < availableTopics.length; avail++) {
            let is_matching = true

            for(let lt = 0; lt < topicInput.text.length; lt++){
                if(availableTopics[avail][lt] != topicInput.text[lt]){
                    is_matching = false
                    continue;
                }
            }

            if(is_matching == false){
                continue;
            }

            let is_monitored = false

            for(let cur = 0; cur < topicModel.count; cur++){
                if (availableTopics[avail] == topicModel.get(cur).topicName){
                    is_monitored = true
                    break;
                }
            }

            if(is_monitored == false){
                suggestionModel.append({topicName : availableTopics[avail]})
            }
        }
    }

    // Only the content area scrolls; the composer is anchored below it.
    Flickable {
        id: pageScroll
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: composerPanel.top
        anchors.bottomMargin: root.panelGap
        contentWidth: width
        contentHeight: Math.max(height, (root.wideLayout ? 190 : 300) * root.px
                                + 2 * root.outerMargin + (root.wideLayout ? 0 : root.panelGap))
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        interactive: contentHeight > height

        ScrollBar.vertical: ScrollBar {
            id: pageBar
            policy: ScrollBar.AsNeeded
        }

        Item {
            width: pageScroll.width
            height: pageScroll.contentHeight

            GridLayout {
                anchors.fill: parent
                anchors.margins: root.outerMargin
                anchors.rightMargin: root.outerMargin + root.scrollGutter
                columns: root.wideLayout ? 2 : 1
                columnSpacing: root.panelGap
                rowSpacing: root.panelGap

                // Joints
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 0
                    Layout.minimumHeight: 120 * root.px
                    Layout.preferredWidth: root.jointPanelWidth
                    Layout.maximumWidth: root.jointPanelWidth
                    Layout.preferredHeight: 190 * root.px

                    color: root.cPanel
                    radius: 12 * root.px
                    border.color: root.cBorder
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: root.panelPadding
                        spacing: root.panelGap

                        Text {
                            Layout.fillWidth: true
                            text: "MelDog Joint States"
                            color: root.cText
                            font.pixelSize: Math.round(24 * root.px)
                            font.weight: Font.DemiBold
                            elide: Text.ElideRight
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 1
                            color: root.cBorder
                        }

                        ListView {
                            id: jointList
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumHeight: 0
                            clip: true
                            spacing: 6 * root.px
                            model: jointModel
                            boundsBehavior: Flickable.StopAtBounds

                            ScrollBar.vertical: ScrollBar {
                                id: jointBar
                                policy: ScrollBar.AsNeeded
                            }

                            delegate: Rectangle {
                                width: Math.max(0, jointList.width - (jointList.contentHeight > jointList.height ? jointBar.width + 4 * root.px : 0))
                                height: root.rowHeight
                                radius: 7 * root.px
                                color: index % 2 === 0 ? root.rowColor : root.alternateRowColor
                                border.color: root.cBorder
                                border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 10 * root.px
                                    anchors.rightMargin: 10 * root.px
                                    spacing: 8 * root.px

                                    Text {
                                        id: jointNameLabel
                                        Layout.fillWidth: true
                                        Layout.minimumWidth: 0
                                        text: model.jointName
                                        color: root.cText
                                        font.pixelSize: Math.round(17 * root.px)
                                        elide: Text.ElideRight

                                        HoverHandler { id: jointNameHover }
                                        ToolTip.visible: jointNameHover.hovered && jointNameLabel.truncated
                                        ToolTip.text: jointNameLabel.text
                                    }

                                    Text {
                                        text: model.jointPosition.toFixed(2) + " rad"
                                        color: root.cSuccess
                                        font.pixelSize: Math.round(17 * root.px)
                                        font.weight: Font.Medium
                                        horizontalAlignment: Text.AlignRight
                                    }
                                }
                            }
                        }
                    }
                }

                // TOPICS
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 0
                    Layout.minimumHeight: 180 * root.px
                    Layout.preferredWidth: root.topicPanelWidth
                    Layout.maximumWidth: root.topicPanelWidth
                    Layout.preferredHeight: 220 * root.px

                    color: root.cPanel
                    radius: 12 * root.px
                    border.color: root.cBorder
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: root.panelPadding
                        spacing: root.panelGap

                        Text {
                            Layout.fillWidth: true
                            text: "MelDog Topic Monitor"
                            color: root.cText
                            font.pixelSize: Math.round(24 * root.px)
                            font.weight: Font.DemiBold
                            elide: Text.ElideRight
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40 * root.px
                            radius: 7 * root.px
                            color: gamepadConnected ? Qt.rgba(0, 1, 0.616, 0.07) : Qt.rgba(1, 0, 0.333, 0.07)
                            border.color: gamepadConnected ? root.cSuccess : root.cDanger
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12 * root.px
                                anchors.rightMargin: 12 * root.px
                                spacing: 9 * root.px

                                Rectangle {
                                    Layout.preferredWidth: 9 * root.px
                                    Layout.preferredHeight: 9 * root.px
                                    radius: width / 2
                                    color: gamepadConnected ? root.cSuccess : root.cDanger
                                }

                                Text {
                                    Layout.fillWidth: true
                                    Layout.minimumWidth: 0
                                    text: "Gamepad connected: " + (gamepadConnected ? "Yes" : "No")
                                    color: gamepadConnected ? root.cSuccess : root.cDanger
                                    font.pixelSize: Math.round(17 * root.px)
                                    font.weight: Font.Medium
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 1
                            color: root.cBorder
                        }

                        ListView {
                            id: topicList
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumHeight: 0
                            clip: true
                            spacing: 6 * root.px
                            model: topicModel
                            boundsBehavior: Flickable.StopAtBounds

                            ScrollBar.vertical: ScrollBar {
                                id: topicBar
                                policy: ScrollBar.AsNeeded
                            }

                            delegate: Rectangle {
                                width: Math.max(0, topicList.width - (topicList.contentHeight > topicList.height ? topicBar.width + 4 * root.px : 0))
                                height: compactRow ? 84 * root.px : root.rowHeight
                                readonly property bool compactRow: width < 420 * root.px
                                id: topicRow
                                radius: 7 * root.px
                                color: index % 2 === 0 ? root.rowColor : root.alternateRowColor
                                border.color: root.cBorder
                                border.width: 1

                                GridLayout {
                                    columns: topicRow.compactRow ? 2 : 3
                                    columnSpacing: 8 * root.px
                                    rowSpacing: 4 * root.px
                                    anchors.fill: parent
                                    anchors.topMargin: 5 * root.px
                                    anchors.bottomMargin: 5 * root.px
                                    anchors.leftMargin: 10 * root.px
                                    anchors.rightMargin: 7 * root.px

                                    Text {
                                        id: topicNameLabel
                                        Layout.columnSpan: topicRow.compactRow ? 2 : 1
                                        Layout.fillWidth: true
                                        Layout.minimumWidth: 0
                                        text: model.topicName
                                        color: root.cText
                                        font.pixelSize: Math.round(17 * root.px)
                                        elide: Text.ElideRight

                                        HoverHandler { id: topicNameHover }
                                        ToolTip.visible: topicNameHover.hovered && topicNameLabel.truncated
                                        ToolTip.text: topicNameLabel.text
                                    }

                                    Text {
                                        Layout.fillWidth: topicRow.compactRow
                                        text: model.frequency == 0
                                              ? "No messages"
                                              : model.frequency.toFixed(1) + " Hz"
                                        color: model.frequency === 0 ? root.cDanger : root.cSuccess
                                        font.pixelSize: Math.round(16 * root.px)
                                        font.weight: Font.Medium
                                        horizontalAlignment: topicRow.compactRow ? Text.AlignLeft : Text.AlignRight
                                    }

                                    Button {
                                        id: deleteButton
                                        Layout.preferredWidth: Math.max(78 * root.px, implicitWidth)
                                        Layout.preferredHeight: 34 * root.px
                                        text: "Delete"
                                        padding: 5 * root.px
                                        hoverEnabled: true
                                        font.pixelSize: Math.round(16 * root.px)
                                        font.weight: Font.Medium

                                        contentItem: Text {
                                            text: deleteButton.text
                                            font: deleteButton.font
                                            color: root.cDanger
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        background: Rectangle {
                                            radius: 5 * root.px
                                            color: deleteButton.down ? Qt.rgba(1, 0, 0.333, 0.22)
                                                   : deleteButton.hovered ? Qt.rgba(1, 0, 0.333, 0.12) : "transparent"
                                            border.color: root.cDanger
                                            border.width: 1
                                        }

                                        onClicked: {
                                            diagnosticsBridge.removeTopic(model.topicName)
                                            updateSuggestions()
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

    // Fixed composer: neither the lists nor the page scroll can push it off-screen.
    Rectangle {
        id: composerPanel
        anchors.left: parent.left
        anchors.leftMargin: root.outerMargin + (root.wideLayout ? root.jointPanelWidth + root.panelGap : 0)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.outerMargin
        width: root.topicPanelWidth
        height: 2 * root.panelPadding + root.controlHeight * (root.stackedControls ? 2 : 1)
                + (root.stackedControls ? 6 * root.px : 0)
        color: root.cPanel
        border.color: root.cBorder
        border.width: 1
        radius: 8 * root.px

        GridLayout {
            anchors.fill: parent
            anchors.margins: root.panelPadding
            columns: root.stackedControls ? 1 : 2
            columnSpacing: 8 * root.px
            rowSpacing: 6 * root.px

            TextField {
                id: topicInput
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                Layout.preferredHeight: root.controlHeight
                placeholderText: "/new_topic"
                text: "/"
                color: root.cText
                placeholderTextColor: root.cMuted
                selectionColor: root.cAccent
                selectedTextColor: "#0F1620"
                font.pixelSize: Math.round(17 * root.px)
                leftPadding: 12 * root.px
                rightPadding: 12 * root.px
                verticalAlignment: Text.AlignVCenter

                background: Rectangle {
                    radius: 7 * root.px
                    color: Qt.rgba(0, 0, 0, 0.30)
                    border.color: topicInput.activeFocus ? root.cAccent : root.cBorder
                    border.width: topicInput.activeFocus ? 2 : 1
                }

                onTextEdited: {
                    updateSuggestions()
                    if (suggestionModel.count > 0)
                        suggestionPopup.open()
                    else
                        suggestionPopup.close()
                }

                Popup {
                    id: suggestionPopup
                    readonly property real itemHeight: 44 * root.px

                    x: 0
                    y: -height - 6 * root.px
                    width: topicInput.width
                    height: Math.min(Math.min(suggestionModel.count, 4) * itemHeight + 2 * padding,
                                     Math.max(2 * padding, composerPanel.y - 12 * root.px))
                    padding: 4 * root.px
                    margins: 4 * root.px
                    focus: false
                    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape

                    background: Rectangle {
                        color: "#151C27"
                        border.color: root.cAccent
                        border.width: 1
                        radius: 8 * root.px
                    }

                    contentItem: ListView {
                        id: suggestionList
                        clip: true
                        model: suggestionModel
                        boundsBehavior: Flickable.StopAtBounds

                        ScrollBar.vertical: ScrollBar {
                            id: suggestionBar
                            policy: ScrollBar.AsNeeded
                        }

                        delegate: ItemDelegate {
                            id: suggestionDelegate
                            width: Math.max(0, suggestionList.width - (suggestionList.contentHeight > suggestionList.height ? suggestionBar.width : 0))
                            height: suggestionPopup.itemHeight
                            hoverEnabled: true

                            background: Rectangle {
                                radius: 5 * root.px
                                color: suggestionDelegate.down ? Qt.rgba(1, 0.616, 0, 0.22)
                                       : suggestionDelegate.hovered ? Qt.rgba(1, 0.616, 0, 0.12) : "transparent"
                            }

                            contentItem: Text {
                                text: model.topicName
                                color: root.cText
                                font.pixelSize: Math.round(17 * root.px)
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 8 * root.px
                                elide: Text.ElideRight
                            }

                            onClicked: {
                                topicInput.text = model.topicName
                                suggestionPopup.close()
                            }
                        }
                    }
                }
            }

            Button {
                id: addButton
                Layout.fillWidth: root.stackedControls
                Layout.preferredWidth: Math.max(122 * root.px, implicitWidth)
                Layout.preferredHeight: root.controlHeight
                text: "Add Topic"
                padding: 8 * root.px
                hoverEnabled: true
                font.pixelSize: Math.round(17 * root.px)
                font.weight: Font.DemiBold

                contentItem: Text {
                    text: addButton.text
                    font: addButton.font
                    color: root.cAccent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    radius: 7 * root.px
                    color: addButton.down ? Qt.rgba(1, 0.616, 0, 0.22)
                           : addButton.hovered ? Qt.rgba(1, 0.616, 0, 0.12) : "transparent"
                    border.color: root.cAccent
                    border.width: 1
                }

                onClicked: {
                    diagnosticsBridge.addTopic(topicInput.text)
                    updateSuggestions()
                    topicInput.text = "/"
                }
            }
        }
    }
}