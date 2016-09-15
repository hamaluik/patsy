package mammoth.render;

import haxe.ds.Vector;
import glm.Mat4;
import glm.Vec2;
import glm.Vec3;
import glm.Vec4;
import mammoth.utilities.Colour;

enum TUniform {
	Bool(x:Bool);
	Int(x:Int);
	Float(x:Float);
	Float2(x:Float, y:Float);
	Float3(x:Float, y:Float, z:Float);
	Float4(x:Float, y:Float, z:Float, w:Float);
	Floats(x:Vector<Float>);
	Vec2(x:Vec2);
	Vec3(x:Vec3);
	Vec4(x:Vec4);
	Mat4(v:Mat4);
	RGB(c:Colour);
	RGBA(c:Colour);
	// TODO: implement textures
	//Texture2D(t:Image, slot:Int);
}