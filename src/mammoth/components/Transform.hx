package mammoth.components;

import edge.IComponent;
import glm.Mat4;
import glm.Vec3;
import glm.Vec4;
import glm.Quat;

class Transform implements IComponent {
    public function new(?pos:Vec3, ?rot:Quat, ?scale:Vec3, ?parent:Transform) {
    }
}
