package mammoth.components;

import edge.IComponent;
import glm.Mat4;
import glm.Vec2;

enum ProjectionMode {
    Orthographic(size:Float);
    Perspective(fieldOfView:Float);
}

class Camera implements IComponent {
    public function new() {
    }
}
