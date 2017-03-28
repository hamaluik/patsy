package mammoth.debug;

import js.html.ImageElement;
import js.html.webgl.RenderingContext;
import js.html.webgl.Shader;
import js.html.webgl.Program;
import js.html.webgl.UniformLocation;
import js.html.webgl.Buffer;
import js.html.webgl.Texture;
import tusk.Tusk;

class DebugView {
    private var context:RenderingContext;
    private var program:Program;
    private var buffer:Buffer;
    private var image:ImageElement;
    private var texture:Texture;

    private var positionLoc:Int = 0;
    private var uvLoc:Int = 0;
    private var colourLoc:Int = 0;

    private var vpLoc:UniformLocation;
    private var textureLoc:UniformLocation;

    public function new() {
        context = mammoth.Mammoth.graphics.context;

        // compile the vertex shader
        var vert:Shader = context.createShader(GL.VERTEX_SHADER);
        context.shaderSource(vert, Tusk.vertexShaderSrc);
        context.compileShader(vert);
		if(!context.getShaderParameter(vert, GL.COMPILE_STATUS)) {
			var info:String = context.getShaderInfoLog(vert);
			throw new Exception(info, true, 'CompileVertShader');
		}

        // compile the fragment shader
        var frag:Shader = context.createShader(GL.FRAGMENT_SHADER);
        context.shaderSource(frag, Tusk.fragmentShaderSrc);
        context.compileShader(frag);
		if(!context.getShaderParameter(frag, GL.COMPILE_STATUS)) {
			var info:String = context.getShaderInfoLog(frag);
			throw new Exception(info, true, 'CompileFragShader');
		}

        // compile the program
        program = context.createProgram();
        context.attachShader(program, vert);
        context.attachShader(program, frag);
        context.linkProgram(program);
		if(!context.getProgramParameter(program, GL.LINK_STATUS)) {
			var info:String = context.getProgramInfoLog(program);
			throw new Exception(info, true, 'LinkProgram');
		}

        // bind the attributes
        context.useProgram(program);
        positionLoc = context.getAttribLocation(program, 'position');
        uvLoc = context.getAttribLocation(program, 'uv');
        colourLoc = context.getAttribLocation(program, 'colour');

        // find the uniform
        vpLoc = context.getUniformLocation(program, 'VP');

        // create the texture
        texture = context.createTexture();
        context.bindTexture(GL.TEXTURE_2D, texture);

        // temporarily create a 1x1 blue texture
        context.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, 1, 1, 0, GL.RGBA, GL.UNSIGNED_BYTE,
              new js.html.Uint8Array([0, 0, 255, 255]));
        textureLoc = context.getUniformLocation(program, 'texture');

        // load the image asynchronously
        image = js.Browser.window.document.createImageElement();
        image.addEventListener('load', function() {
            context.bindTexture(GL.TEXTURE_2D, texture);
            context.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
            context.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
            context.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
            context.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
            context.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
            context.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, image);
        });
        image.src = Tusk.textureSrc;

        // create the buffer
        buffer = context.createBuffer();

        // finish up
        context.useProgram(null);
    }

    public function draw():Void {
        Tusk.screenWidth = mammoth.Mammoth.width;
        Tusk.screenHeight = mammoth.Mammoth.height;

        if(Tusk.numVertices == 0) return;
        
        context.enable(GL.CULL_FACE);
        context.cullFace(GL.BACK);

        context.disable(GL.DEPTH_TEST);
        context.depthFunc(GL.ALWAYS);
        context.depthMask(false);

        context.enable(GL.BLEND);
        context.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA);

        context.useProgram(program);

        context.bindBuffer(GL.ARRAY_BUFFER, buffer);
        context.bufferData(GL.ARRAY_BUFFER, Tusk.buffer, GL.DYNAMIC_DRAW);

        context.uniformMatrix4fv(vpLoc, false, cast(Tusk.vpMatrix));
        context.uniform1i(textureLoc, 0);

        context.activeTexture(GL.TEXTURE0);
        context.bindTexture(GL.TEXTURE_2D, texture);

        context.enableVertexAttribArray(positionLoc);
        context.vertexAttribPointer(positionLoc, 3, GL.FLOAT, false, 9*4, 0);
        context.enableVertexAttribArray(uvLoc);
        context.vertexAttribPointer(uvLoc, 2, GL.FLOAT, false, 9*4, 3*4);
        context.enableVertexAttribArray(colourLoc);
        context.vertexAttribPointer(colourLoc, 4, GL.FLOAT, false, 9*4, 5*4);

        context.drawArrays(GL.TRIANGLES, 0, Tusk.numVertices);
    }
}