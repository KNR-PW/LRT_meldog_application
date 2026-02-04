import QtQuick 2.15
import QtQuick3D

Node {
    id: rootNode 

    property bool pickEnabled: true
    property real robotScale: 0.001
    property string selectedLeg: ""

    scale: Qt.vector3d(robotScale, robotScale, robotScale)

    PrincipledMaterial { id: legMat; baseColor: "#9aa0a6"; roughness: 0.85 }
    PrincipledMaterial { id: legSelMat; baseColor: "#2c9bd6"; roughness: 0.5 }

    // TRUNK 
    Node {
        id: trunk
        position: Qt.vector3d(0.0, 0.0, 0.55)
        rotation: Qt.quaternion(1, 0, 0, 0)

        Model {
            source: "#Cube"
            materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
            pickable: false
            position: Qt.vector3d(0, 0, 0)
            scale: Qt.vector3d(0.8/100.0, 0.2/100.0, 0.1/100.0)
        }

        Model {
            source: "#Cube"
            materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
            pickable: false
            position: Qt.vector3d(0.0, 0.175, 0.0)
            scale: Qt.vector3d(0.3/100.0, 0.15/100.0, 0.1/100.0)
        }

        Model {
            source: "#Cube"
            materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
            pickable: false
            position: Qt.vector3d(0.0, -0.175, 0.0)
            scale: Qt.vector3d(0.3/100.0, 0.15/100.0, 0.1/100.0)
        }
    }

    Model {
        source: "meshes/foot_vis.mesh"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_lf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.324, 0.2675, 0.05)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    Model {
        source: "meshes/LL_vis_v2.mesh"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_lf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.324, 0.2675, 0.3)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    Model {
        source: "meshes/upper_limb_test.mesh"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_lf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.324, 0.2675, 0.55)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    Model {
        source: "meshes/hip_test.mesh"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_lf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.15, 0.175, 0.55)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    // FRONT RIGHT LEG
    Model {
        source: "meshes/foot_vis.stl"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_rf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.324, -0.2675, 0.05)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    Model {
        source: "meshes/LL_vis_v2.stl"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_rf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.324, -0.2675, 0.3)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    Model {
        source: "meshes/r_upper_limb_vis.stl"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_rf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.324, -0.2675, 0.55)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    Model {
        source: "meshes/front_right_hip.stl"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_rf"
        pickable: root.pickEnabled
        position: Qt.vector3d(0.15, -0.175, 0.55)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    // REAR LEFT LEG
    Model {
        source: "meshes/foot_vis.stl"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_lr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.324, 0.2675, 0.05)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    Model {
        source: "meshes/LL_vis_v2.stl"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_lr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.324, 0.2675, 0.3)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    Model {
        source: "meshes/upper_limb_test.stl"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_lr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.324, 0.2675, 0.55)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    Model {
        source: "meshes/rear_left_hip.stl"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_lr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.15, 0.175, 0.55)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    // REAR RIGHT LEG
    Model {
        source: "meshes/foot_vis.stl"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_rr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.324, -0.2675, 0.05)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    Model {
        source: "meshes/LL_vis_v2.stl"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_rr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.324, -0.2675, 0.3)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    Model {
        source: "meshes/r_upper_limb_vis.stl"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_rr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.324, -0.2675, 0.55)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }

    Model {
        source: "meshes/rear_right_hip.stl"
        materials: [ (root.selectedLeg === "leg_lf") ? legSelMat : legMat ]
        objectName: "leg_rr"
        pickable: root.pickEnabled
        position: Qt.vector3d(-0.15, -0.175, 0.55)
        rotation: Qt.quaternion(0, 0, 0, 1)
    }
}