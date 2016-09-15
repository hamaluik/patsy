package mammoth.components;

import edge.IComponent;
import glm.Mat4;
import glm.Vec2;
import mammoth.utilities.Colour;

enum ProjectionMode {
    Orthographic(size:Float);
    Perspective(fieldOfView:Float);
}

class Camera implements IComponent {
    public var pDirty:Bool = true;
    public var vDirty:Bool = true;

    public var near(default, set):Float = 0.1;
    public var far(default, set):Float = 100;
    public var projection:ProjectionMode = ProjectionMode.Perspective(60);
    public var viewportMin:Vec2 = new Vec2(0, 0);
    public var viewportMax:Vec2 = new Vec2(1, 1);
    public var clearColour:Colour = Colour.Black;

    public var v:Mat4 = new Mat4(1.0);
    public var p:Mat4 = new Mat4(1.0);
    public var vp:Mat4 = new Mat4(1.0);

    public function new() {}
}
