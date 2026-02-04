import QtQuick
import QtQuick3D
Node {
    id: _STL_BINARY_
    Model {
        source: "meshes/node.mesh"

        DefaultMaterial {
            id: defaultMaterial_material
        }
        materials: [
            defaultMaterial_material
        ]
    }
}
