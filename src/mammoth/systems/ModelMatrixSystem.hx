/*
 * Copyright (c) 2017 Kenton Hamaluik
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *     http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/
package mammoth.systems;

import edge.ISystem;
import glm.GLM;
import glm.Quat;
import glm.Vec3;
import glm.Mat4;
import mammoth.components.Transform;
import mammoth.Timing;

class ModelMatrixSystem implements ISystem {
    private var position:Vec3 = new Vec3();
    private var rotation:Quat = new Quat();
    private var scale:Vec3 = new Vec3();

    private var m_position:Mat4 = new Mat4();
    private var m_rotation:Mat4 = Mat4.identity(new Mat4());
    private var m_scale:Mat4 = new Mat4();

    private function calculateModelMatrix(transform:Transform) {
        transform.wasDirty = false;
        if(!transform.dirty)
            return;

        // interpolate based on timing
        Vec3.lerp(transform.lastPosition, transform.position, Timing.alpha, position);
        Quat.slerp(transform.lastRotation, transform.rotation, Timing.alpha, rotation);
        Vec3.lerp(transform.lastScale, transform.scale, Timing.alpha, scale);

        // calculate the matrices for the transform components
        GLM.translate(position.x, position.y, position.z, m_position);
        // TODO: rotation
        GLM.scale(scale.x, scale.y, scale.z, m_scale);

        // multiply them together for the full modelview!
        // TODO: order?
        Mat4.multMat(m_rotation, m_scale, transform.m);
        Mat4.multMat(m_position, transform.m, transform.m);

        if(transform.parent != null) {
            calculateModelMatrix(transform.parent);
            // TODO: order?
            Mat4.multMat(transform.parent.m, transform.m, transform.m);
        }

        transform.dirty = false;
        transform.wasDirty = true;
    }

    public function update(transform:Transform) {
        calculateModelMatrix(transform);
    }
}

