package mammoth.components;

import edge.IComponent;
import glm.Mat4;
import glm.Vec3;
import glm.Vec4;
import glm.Quat;

class Transform implements IComponent {
	public var dirty:Bool = true;
	public var wasDirty:Bool = false;

	public var parent:Transform = null;
	public var position:Vec3 = new Vec3();
	public var rotation:Quat = new Quat().setIdentity();
	public var scale:Vec3 = new Vec3(1, 1, 1);
    
    public var m:Mat4 = Mat4.identity();

    public function new(?position:Vec3, ?rotation:Quat, ?scale:Vec3, ?parent:Transform) {
    	if(position != null) this.position = position;
    	if(rotation != null) this.rotation = rotation;
    	if(scale != null)    this.scale = scale;
    	if(parent != null)   this.parent = parent;
    }

    public function setPosition(x:Float, y:Float, z:Float):Transform {
        position.x = x;
        position.y = y;
        position.z = z;
        dirty = true;
        return this;
    }

    public function setRotation(rot:Quat):Transform {
        rotation.x = rot.x;
        rotation.y = rot.y;
        rotation.z = rot.z;
        rotation.w = rot.w;
        dirty = true;
        return this;
    }

    public function setScale(sx:Float, sy:Float, sz:Float):Transform {
        scale.x = sx;
        scale.y = sy;
        scale.z = sz;
        dirty = true;
        return this;
    }
}
