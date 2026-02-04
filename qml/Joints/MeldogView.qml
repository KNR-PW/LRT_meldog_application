import QtQuick 2.15
import QtQuick3D 
import "qrc:/MeldogModel"

Item {
    id: root
    anchors.fill: parent

    // "leg_lf", "leg_rf", "leg_lr", "leg_rr"
    signal legSelected(string legId)

    property string selectedLeg: ""

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
                position: Qt.vector3d(0, 0, 0.55)
                eulerRotation.x: root._pitchDeg
                eulerRotation.y: root._yawDeg

                PerspectiveCamera {
                    id: cam
                    z: root._distance
                    clipNear: 0.01
                    clipFar: 100.0
                }
            }

            DirectionalLight { eulerRotation.x: -35; eulerRotation.y: 45; brightness: 1.2 }
            DirectionalLight { eulerRotation.x: -15; eulerRotation.y: -120; brightness: 0.6 }

            MeldogModel {
                id: robot
                pickEnabled: true
                robotScale: 1.0
            }
        }

        camera: cam
    }

    property real _yawDeg: 35
    property real _pitchDeg: -20
    property real _distance: 2.2   

    DragHandler {
        acceptedButtons: Qt.LeftButton
        onTranslationChanged: {
            root._yawDeg += translation.x * 0.25
            root._pitchDeg += translation.y * 0.25

            if (root._pitchDeg < -85) root._pitchDeg = -85
            if (root._pitchDeg >  85) root._pitchDeg =  85
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
                root.legSelected(r.objectHit.objectName)
            }
        }
    }
}
