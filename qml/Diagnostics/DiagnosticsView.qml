import QtQuick 2.15
import QtQuick.Controls


Rectangle {
    width: 700
    height: 450
    color: "#202630"
    property real px: 1.0


    // Joints

    ListModel {
        id: jointModel

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
    }
    


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
    ListModel {
        id: topicModel

        ListElement {
            topicName: "/joint_states"
            frequency: 50.0
        }

        ListElement {
            topicName: "/tf"
            frequency: 30.0
        }
    }

    Column {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 20
        width: 500
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
                }
            }
        }

        Row {
            spacing: 10

            TextField {
                id: topicInput
                width: 300
                placeholderText: "/new_topic"
            }

            Button {
                text: "Add Topic"

                onClicked: {
                    if (topicInput.text!==""){
                        topicModel.append({
                            topicName: topicInput.text,
                            frequency: 0.0
                        })
                    }

                    topicInput.text = ""
                }
            }
        }
    }


}
