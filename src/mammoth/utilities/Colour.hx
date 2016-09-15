package mammoth.utilities;

import glm.Vec3;
import glm.Vec4;

class Colour {
    public var r:Float = 0;
    public var g:Float = 0;
    public var b:Float = 0;
    public var a:Float = 1;

    public function new(?r:Float, ?g:Float, ?b:Float, ?a:Float) {
        if(r != null) this.r = r;
        if(g != null) this.g = g;
        if(b != null) this.b = b;
        if(a != null) this.a = a;
    }

    public function toVec3():Vec3 {
        return new Vec3(r, g, b);
    }

    public function toVec4():Vec4 {
        return new Vec4(r, g, b, a);
    }

    public static var Black:Colour = new Colour(0, 0, 0);
    public static var White:Colour = new Colour(1, 1, 1);
}