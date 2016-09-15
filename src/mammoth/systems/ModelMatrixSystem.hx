package mammoth.systems;

import edge.ISystem;
import glm.Mat4;
import glm.GLM;
import mammoth.components.Transform;

class ModelMatrixSystem implements ISystem {
    private function calculateModelMatrix(transform:Transform) {
        transform.wasDirty = false;
        if(!transform.dirty)
            return;

        transform.m = GLM.translate(
            GLM.rotation(
                GLM.scale(transform.scale),
                transform.rotation
            ),
            transform.position);

        if(transform.parent != null) {
            calculateModelMatrix(transform.parent);
            transform.m = transform.parent.m * transform.m;
        }

        transform.dirty = false;
        transform.wasDirty = true;
    }

    public function update(transform:Transform) {
        calculateModelMatrix(transform);
    }
}

