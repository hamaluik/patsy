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
import glm.Projection;
import mammoth.components.Transform;
import mammoth.components.Camera;

class CameraSystem implements ISystem {
    public function update(transform:Transform, camera:Camera) {
        if(camera.vDirty || transform.wasDirty) {
            camera.v = transform.m.clone().invert();

            mammoth.Log.debug('camera model matrix:');
            mammoth.Log.debug(transform.m);
            mammoth.Log.debug('camera view matrix:');
            mammoth.Log.debug(camera.v);
        }

        if(camera.pDirty) {
            var aspect:Float = Mammoth.width / Mammoth.height;
            camera.p = switch (camera.projection) {
                case ProjectionMode.Perspective(fov): Projection.perspective(fov, aspect, camera.near, camera.far);
                case ProjectionMode.Orthographic(halfY): {
                    var halfX:Float = aspect * halfY;
                    Projection.ortho(-halfX, halfX, -halfY, halfY, camera.near, camera.far);
                }
            };
        }

        if(camera.vDirty || camera.pDirty) {
            camera.vp = camera.v * camera.p;
            camera.vDirty = false;
            camera.pDirty = false;
        }
    }
}

