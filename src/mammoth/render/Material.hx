package mammoth.render;

import js.html.webgl.Program;
import js.html.webgl.RenderingContext;
import js.html.webgl.Shader;
import mammoth.debug.Exception;
import mammoth.Graphics;
import mammoth.Mammoth;
import mammoth.GL;

// TODO: generalize for cross-compatibility?
class Material {
	private var context:RenderingContext;
	private var program:Program;
	private var vertexShader:Shader;
	private var fragmentShader:Shader;

	public function new(graphics:Graphics) {
		this.context = graphics.context;
	}

	public function setVertexShader(source:String) {
		vertexShader = context.createShader(GL.VERTEX_SHADER);
		context.shaderSource(vertexShader, source);
		context.compileShader(vertexShader);
		if(!context.getShaderParameter(vertexShader, GL.COMPILE_STATUS)) {
			var info:String = context.getShaderInfoLog(vertexShader);
			throw new Exception(info, true, 'CompileVertexShader');
		}
	}

	public function setFragmentShader(source:String) {
		fragmentShader = context.createShader(GL.FRAGMENT_SHADER);
		context.shaderSource(fragmentShader, source);
		context.compileShader(fragmentShader);
		if(!context.getShaderParameter(fragmentShader, GL.COMPILE_STATUS)) {
			var info:String = context.getShaderInfoLog(fragmentShader);
			throw new Exception(info, true, 'CompileFragmentShader');
		}
	}

	public function compile() {
		program = context.createProgram();
		context.attachShader(program, vertexShader);
		context.attachShader(program, fragmentShader);

		context.linkProgram(program);
		if(!context.getProgramParameter(program, GL.LINK_STATUS)) {
			var info:String = context.getProgramInfoLog(program);
			throw new Exception(info, true, 'LinkProgram');
		}
	}

	public function apply() {
		context.useProgram(program);

		// TODO: bind uniforms
	}
}