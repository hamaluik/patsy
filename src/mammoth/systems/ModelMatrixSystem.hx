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
import glm.Mat4;
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

