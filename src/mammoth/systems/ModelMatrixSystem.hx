package mammoth.systems;

import edge.ISystem;
import glm.Mat4;
import glm.GLM;
import mammoth.components.Transform;

class ModelMatrixSystem implements ISystem {
    public function update(transform:Transform) {
        transform.wasDirty = false;
        if(!transform.dirty)
            return;

        transform.m = GLM.translate(
            GLM.rotation(
                GLM.scale(transform.scale),
                transform.rotation
            ),
            transform.position);

        transform.dirty = false;
        transform.wasDirty = true;
    }
}

