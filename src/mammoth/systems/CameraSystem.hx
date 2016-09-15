package mammoth.systems;

import edge.ISystem;
import glm.Projection;
import mammoth.components.Transform;
import mammoth.components.Camera;

class CameraSystem implements ISystem {
    public function update(transform:Transform, camera:Camera) {
        if(camera.vDirty || transform.wasDirty)
            camera.v = transform.m.clone().invert();

        if(camera.pDirty) {
            var aspect:Float = Mammoth.width / Mammoth.height;
            camera.p = switch (camera.projection) {
                case ProjectionMode.Perspective(fov): Projection.perspective(fov * Math.PI / 180, aspect, camera.near, camera.far);
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

