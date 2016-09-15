package mammoth.render;

import js.html.Float32Array;
import js.html.Int16Array;
import js.html.webgl.Buffer;
import js.html.webgl.RenderingContext;

class Mesh {
	private var context:RenderingContext;

	@:allow(mammoth.systems.RenderSystem)
	private var vertexBuffer:Buffer;
	@:allow(mammoth.systems.RenderSystem)
	private var indexBuffer:Buffer;

	@:allow(mammoth.systems.RenderSystem)
	private var vertexCount:Int;

	public var name(default, null):String;
	public var attributeNames(default, null):Array<String>;

	public function new(name:String, graphics:Graphics, attributeNames:Array<String>) {
		this.name = name;
		this.context = graphics.context;
		this.attributeNames = attributeNames;

		vertexBuffer = context.createBuffer();
		indexBuffer = context.createBuffer();
	}

	public function setVertexData(data:Array<Float>) {
		context.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		context.bufferData(GL.ARRAY_BUFFER, new Float32Array(data), GL.STATIC_DRAW);
		context.bindBuffer(GL.ARRAY_BUFFER, null);
	}

	public function setIndexData(data:Array<Int>) {
		context.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
		context.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Int16Array(data), GL.STATIC_DRAW);
		context.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		vertexCount = data.length;
	}
}