import QtQuick 2.15
import QtQuick3D
import "qrc:/MeldogModel"

Item {
    id: root
    anchors.fill: parent

    // "leg_lf", "leg_rf", "leg_lr", "leg_rr"
    signal legSelected(string legId)
    property string selectedLeg: ""

    property string _currentLeg: selectedLeg
    onSelectedLegChanged: _currentLeg = selectedLeg

    property real _yawDeg: 35
    property real _pitchDeg: 35
    property real _yawStartDeg: 0
    property real _pitchStartDeg: 0

    property real _distance: 2.2
    readonly property vector3d _pivot: Qt.vector3d(0, 0.50, 0)
    property real groundOffset: -0.01
    property vector2d _lastDrag: Qt.vector2d(0, 0)

    View3D {
        id: view
        anchors.fill: parent

        environment: SceneEnvironment {
            clearColor: "#0D0F14"
            backgroundMode: SceneEnvironment.Color
        }

        Node {
            id: sceneRoot

            Node {
                id: orbitPivot
                position: root._pivot
                eulerRotation.y: root._yawDeg

                Node {
                    id: pitchNode
                    eulerRotation.x: -root._pitchDeg

                    PerspectiveCamera {
                        id: cam
                        z: root._distance
                        clipNear: 0.001
                        clipFar: 10000.0
                    }
                }
            }

            DirectionalLight {
                eulerRotation.x: -45
                eulerRotation.y: 35
                brightness: 1.4
                castsShadow: true
            }

            DirectionalLight {
                eulerRotation.x: -20
                eulerRotation.y: -120
                brightness: 0.6
            }

            Model {
                source: "#Rectangle"
                eulerRotation.x: -90      
                y: 0
                scale: Qt.vector3d(8, 8, 1)
                pickable: false
                receivesShadows: true
                castsShadows: false

                materials: PrincipledMaterial {
                    baseColor: "#151a22"
                    roughness: 0.45
                    metalness: 0.0
                }
            }

            Node {
                id: robotRig
                eulerRotation.x: -90
                y: root.groundOffset

                MeldogModel {
                    id: robot
                    pickEnabled: true
                    robotScale: 0.001
                    selectedLeg: root.selectedLeg
                }
            }
        }

        camera: cam
    }

    DragHandler {
        id: orbitDrag
        acceptedButtons: Qt.LeftButton
        target: null

        onActiveChanged: {
            if (active) {
                root._yawStartDeg = root._yawDeg
                root._pitchStartDeg = root._pitchDeg
            }
        }

        onTranslationChanged: {
            root._yawDeg = root._yawStartDeg - translation.x * 0.25
            root._pitchDeg = root._pitchStartDeg + translation.y * 0.25

            if (root._pitchDeg < 5)  root._pitchDeg = 5
            if (root._pitchDeg > 89) root._pitchDeg = 89
        }
    }


    WheelHandler {
        onWheel: (event) => {
            root._distance -= event.angleDelta.y * 0.0015
            if (root._distance < 0.6) root._distance = 0.6
            if (root._distance > 8.0) root._distance = 8.0
        }
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: {
            const p = point.position
            const r = view.pick(p.x, p.y)
            if (r.objectHit && r.objectHit.objectName) {
                const legId = r.objectHit.objectName
                root._currentLeg = legId
                root.legSelected(legId)
            }
        }
    }
}
