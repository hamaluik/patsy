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

    public var near:Float = 0.1;
    public var far:Float = 100;
    public var projection:ProjectionMode = ProjectionMode.Perspective(60);
    public var viewportMin:Vec2 = new Vec2(0, 0);
    public var viewportMax:Vec2 = new Vec2(1, 1);
    public var clearColour:Colour = Colour.Black;

    public var v:Mat4 = new Mat4(1.0);
    public var p:Mat4 = new Mat4(1.0);
    public var vp:Mat4 = new Mat4(1.0);

    public function new() {}

    public function setNearFar(near:Float, far:Float):Camera {
        this.near = near;
        this.far = far;
        pDirty = true;
        return this;
    }

    public function setProjection(projection:ProjectionMode):Camera {
        this.projection = projection;
        pDirty = true;
        return this;
    }

    public function setViewport(min:Vec2, max:Vec2):Camera {
        this.viewportMin = min;
        this.viewportMax = max;
        return this;
    }

    public function setClearColour(colour:Colour):Camera {
        this.clearColour = colour;
        return this;
    }
}
