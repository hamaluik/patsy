package mammoth.render;

import js.html.webgl.RenderingContext;
import mammoth.render.TAttribute;

@:allow(mammoth.render.Material)
class Attribute {
	public var location(default, null):Int;
	public var bound(default, null):Bool = false;
	public var type(default, null):TAttribute;
	public var stride(default, null):Int;
	public var offset(default, null):Int;

	public function new(type:TAttribute, stride:Int, offset:Int) {
		this.type = type;
		this.stride = stride;
		this.offset = offset;
	}
}