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
package mammoth.components;

import edge.IComponent;
import glm.Mat4;
import glm.Vec3;
import glm.Quat;

class Transform implements IComponent {
	public var dirty:Bool = true;
	public var wasDirty:Bool = false;

    public var name:String = '';
	public var parent:Transform = null;
	public var position:Vec3 = new Vec3();
	public var rotation:Quat = Quat.identity(new Quat());
	public var scale:Vec3 = new Vec3(1, 1, 1);
    
    public var m:Mat4 = Mat4.identity(new Mat4());

    public var m_position:Mat4 = Mat4.identity(new Mat4());
    public var m_rotation:Mat4 = Mat4.identity(new Mat4());
    public var m_scale:Mat4 = Mat4.identity(new Mat4());

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
