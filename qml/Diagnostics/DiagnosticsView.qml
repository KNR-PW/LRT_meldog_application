import QtQuick 2.15
import QtQuick.Controls


Rectangle {
    width: 700
    height: 450
    color: "#0F1620"
    property real px: 1.0



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

    // Joints

    Column {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 30
        spacing: 20
        width: 500

        Text {
            text: "MelDog Joint States"
            color: "white"
            font.pixelSize: 26
            renderType: Text.NativeRendering
        }

        Repeater {
            model: jointModel

            delegate: Row {
                spacing: 30

                Text {
                    width: 200
                    text: model.jointName
                    color: "white"
                    font.pixelSize: 20
                    renderType: Text.NativeRendering
                }

                Text {
                    text: model.jointPosition.toFixed(2) + " rad"
                    color: "lightgreen"
                    renderType: Text.NativeRendering
                    font.pixelSize: 20
                }
            }
        }
    }
    
    // TOPICS


    Column {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 20
        width: 500
        height: 400
        spacing: 20

        Text {
            text: "MelDog Topic Monitor"
            color: "white"
            renderType: Text.NativeRendering
            font.pixelSize: 26
        }

        Column {
            width: parent.width
            spacing: 12

            Repeater {
                model: topicModel

                delegate: Row {
                    spacing: 20

                    Text {
                        width: 300
                        text: model.topicName
                        color: "white"
                        renderType: Text.NativeRendering
                        font.pixelSize: 18
                    }

                    Text {
                        text : {if (model.frequency == 0){
                            text: "No messages"
                        }else{
                            text: model.frequency.toFixed(1) + " Hz"
                        }}
                        color: model.frequency === 0? "red" : "lightgreen"
                        renderType: Text.NativeRendering
                        font.pixelSize: 18
                    }

                    Button {
                        text: "Delete"

                        background: Rectangle {
                            color: "#f45757"
                        }

                        onClicked: {
                            diagnosticsBridge.removeTopic(model.topicName)
                            updateSuggestions()
                        }
                    }
                }
            }
        }

        Row {
            spacing: 10

            TextField {
                id: topicInput
                width: 300
                placeholderText: "/new_topic"
                text: "/"
                
                onTextEdited: {
                    updateSuggestions()
                    if (suggestionModel.count > 0)
                        suggestionPopup.open()
                    else
                        suggestionPopup.close()

                }


                Popup {
                    id: suggestionPopup

                    x: 0
                    y: -height - 4

                    width: topicInput.width
                    height: Math.min(suggestionModel.count, 4) * 40 + 4

                    padding: 2
                    focus: false
                    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape


                    background: Rectangle {
                        color: "#1D2A3A"
                        border.color: "#455B77"
                        radius: 6
                    }

                    contentItem: ListView {
                        id: suggestionList
                        clip: true
                        model: suggestionModel

                            delegate: ItemDelegate {
                            width: suggestionList.width
                            height: 40

                            background: Rectangle {
                                color: parent.hovered ? "#31465F" : "#1D2A3A"
                            }

                                contentItem: Text {
                                text: model.topicName
                                color: "white"
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 10
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
                text: "Add Topic"

                onClicked: {
                    diagnosticsBridge.addTopic(topicInput.text)
                    updateSuggestions()
                    topicInput.text = "/"
                }
            }
        }
    }
}
