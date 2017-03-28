package tusk;

import tusk.macros.FileContents;

#if js
typedef FloatArray = js.html.Float32Array;
#else
typedef FloatArray = haxe.io.Float32Array;
#end

class Tusk {
    public static var vertexShaderSrc(default, null):String = FileContents.contents('tusk/shaders/vertex.glsl');
    public static var fragmentShaderSrc(default, null):String = FileContents.contents('tusk/shaders/fragment.glsl');
    public static var textureSrc(default, null):String = 'data:image/png;base64,' + FileContents.base64contents('tusk/texture.png');

    public static var screenWidth(default, set):Float = 1;
    private static function set_screenWidth(w:Float):Float {
        screenWidth = w;
        GLM.orthographic(0, screenWidth, 0, screenHeight, 0, 1, vpMatrix);
        return screenWidth;
    }

    public static var screenHeight(default, set):Float = 1;
    private static function set_screenHeight(h:Float):Float {
        screenHeight = h;
        GLM.orthographic(0, screenWidth, 0, screenHeight, 0, 1, vpMatrix);
        return screenHeight;
    }

    public static var vpMatrix(default, null):Mat4 = Mat4.identity(new Mat4());

    public static var buffer(default, null):FloatArray = new FloatArray(9 * 6 * 64);
    public static var numVertices(default, null):Int = 0;

    private function new() {}

    public static function newFrame():Void {
        numVertices = 0;
    }

    private static function addVertex(x:Float, y:Float, z:Float, u:Float, v:Float, colour:Vec4):Void {
        var i:Int = numVertices * 9;
        buffer[i + 0] = x;
        buffer[i + 1] = y;
        buffer[i + 2] = z;
        buffer[i + 3] = u;
        buffer[i + 4] = v;
        buffer[i + 5] = colour.r;
        buffer[i + 6] = colour.g;
        buffer[i + 7] = colour.b;
        buffer[i + 8] = colour.a;
        numVertices++;

        if((numVertices * 9) >= buffer.length) {
            // resize the buffer
            var newBuffer:FloatArray = new FloatArray(buffer.length + (9 * 6 * 64));
            for(i in 0...buffer.length)
                newBuffer[i] = buffer[i];
            buffer = newBuffer;
        }
    }

    public static function drawWindow(x:Float, y:Float, w:Float, h:Float, z:Float = 1.0, title:String):Void {
        // draw the header
        addVertex(x + 0, y + 0, z, 0, 0, TuskConfig.window_headerColour);
        addVertex(x + 0, y + TuskConfig.window_headerHeight, z, 0, 0, TuskConfig.window_headerColour);
        addVertex(x + w, y + 0, z, 0, 0, TuskConfig.window_headerColour);
        addVertex(x + w, y + 0, z, 0, 0, TuskConfig.window_headerColour);
        addVertex(x + 0, y + TuskConfig.window_headerHeight, z, 0, 0, TuskConfig.window_headerColour);
        addVertex(x + w, y + TuskConfig.window_headerHeight, z, 0, 0, TuskConfig.window_headerColour);

        // draw the main body
        addVertex(x + 0, y + TuskConfig.window_headerHeight, z, 0, 0, TuskConfig.window_bodyColour);
        addVertex(x + 0, y + h, z, 0, 0, TuskConfig.window_bodyColour);
        addVertex(x + w, y + TuskConfig.window_headerHeight, z, 0, 0, TuskConfig.window_bodyColour);
        addVertex(x + w, y + TuskConfig.window_headerHeight, z, 0, 0, TuskConfig.window_bodyColour);
        addVertex(x + 0, y + h, z, 0, 0, TuskConfig.window_bodyColour);
        addVertex(x + w, y + h, z, 0, 0, TuskConfig.window_bodyColour);
    }
}