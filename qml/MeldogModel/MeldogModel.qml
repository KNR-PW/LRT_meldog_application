import QtQuick 2.15
import QtQuick3D

Node {
    id: root

    property bool pickEnabled: true
    property real robotScale: 0.001
    property string selectedLeg: ""
    readonly property vector3d meshS: Qt.vector3d(robotScale, robotScale, robotScale)

    PrincipledMaterial { id: legMat;    baseColor: "#9aa0a6"; roughness: 0.85 }
    PrincipledMaterial { id: legSelMat; baseColor: "#2c9bd6"; roughness: 0.5 }

    // TRUNK
    Node {
        id: trunk
        position: Qt.vector3d(0.0, 0.0, 0.55)
        rotation: Qt.quaternion(1, 0, 0, 0)

        Model {
            source: "#Cube"
            materials: [ legMat ]
            pickable: false
            position: Qt.vector3d(0, 0, 0)
            scale: Qt.vector3d(0.8 / 100.0, 0.2 / 100.0, 0.1 / 100.0)
        }

        Model {
            source: "#Cube"
            materials: [ legMat ]
            pickable: false
            position: Qt.vector3d(0.0, 0.175, 0.0)
            scale: Qt.vector3d(0.3 / 100.0, 0.15 / 100.0, 0.1 / 100.0)
        }

        Model {
            source: "#Cube"
            materials: [ legMat ]
            pickable: false
            position: Qt.vector3d(0.0, -0.175, 0.0)
            scale: Qt.vector3d(0.3 / 100.0, 0.15 / 100.0, 0.1 / 100.0)
        }
    }

    // FRONT LEFT LEG
    Model {
        source: "Imported/foot_vis/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_lf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.324, 0.2675, 0.05)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    Model {
        source: "Imported/LL_vis_v2/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_lf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.324, 0.2675, 0.3)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    Model {
        source: "Imported/upper_limb_test/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_lf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.324, 0.2675, 0.55)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    Model {
        source: "Imported/hip_test/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_lf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.15, 0.175, 0.55)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    // FRONT RIGHT LEG
    Model {
        source: "Imported/foot_vis/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_rf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.324, -0.2675, 0.05)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    Model {
        source: "Imported/LL_vis_v2/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_rf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.324, -0.2675, 0.3)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    Model {
        source: "Imported/r_upper_limb_vis/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_rf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.324, -0.2675, 0.55)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    Model {
        source: "Imported/front_right_hip/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_rf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.15, -0.175, 0.55)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    // REAR LEFT LEG
    Model {
        source: "Imported/foot_vis/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_lr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.324, 0.2675, 0.05)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    Model {
        source: "Imported/LL_vis_v2/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_lr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.324, 0.2675, 0.3)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    Model {
        source: "Imported/upper_limb_test/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_lr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.324, 0.2675, 0.55)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    Model {
        source: "Imported/rear_left_hip/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_lr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.15, 0.175, 0.55)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    // REAR RIGHT LEG
    Model {
        source: "Imported/foot_vis/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_rr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.324, -0.2675, 0.05)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    Model {
        source: "Imported/LL_vis_v2/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_rr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.324, -0.2675, 0.3)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    Model {
        source: "Imported/r_upper_limb_vis/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_rr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.324, -0.2675, 0.55)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }

    Model {
        source: "Imported/rear_right_hip/meshes/node.mesh"
        scale: root.meshS
        materials: [ (root.selectedLeg === objectName) ? legSelMat : legMat ]
        objectName: "leg_rr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.15, -0.175, 0.55)
        rotation: Qt.quaternion(1, 0, 0, 0)
    }
}
