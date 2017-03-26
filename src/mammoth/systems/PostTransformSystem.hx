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
import mammoth.components.Transform;

class PostTransformSystem implements ISystem {
    public function update(transform:Transform) {
        // skip any unecessary calculations
        if(transform.dirty) return;

        // check to see if anything changed
        // if it did, the matrix is definitely dirty!
        if(!transform.position.equals(transform.lastPosition)) {
            transform.dirty = true;
            return;
        }
        if(!transform.rotation.equals(transform.lastRotation)) {
            transform.dirty = true;
            return;
        }
        if(!transform.scale.equals(transform.lastScale)) {
            transform.dirty = true;
            return;
        }
    }
}

