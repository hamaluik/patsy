package tusk;

import tusk.macros.FileContents;
import tusk.text.Font;

#if js
typedef FloatArray = js.html.Float32Array;
#else
typedef FloatArray = haxe.io.Float32Array;
#end

class Tusk {
    public static var vertexShaderSrc(default, null):String = FileContents.contents('tusk/shaders/vertex.glsl');
    public static var fragmentShaderSrc(default, null):String = FileContents.contents('tusk/shaders/fragment.glsl');
    public static var fontTextureSrc(default, null):String = 'data:image/png;base64,' + FileContents.base64contents('tusk/font/coderscrux.png');
    public static var fontSrc(default, null):String = FileContents.contents('tusk/font/coderscrux.json');

    public static var screenWidth(default, set):Float = 1;
    private static function set_screenWidth(w:Float):Float {
        if(w != screenWidth) vpDirty = true;
        return screenWidth = w;
    }

    public static var screenHeight(default, set):Float = 1;
    private static function set_screenHeight(h:Float):Float {
        if(h != screenHeight) vpDirty = true;
        return screenHeight = h;
    }

    private static var vpDirty:Bool = true;
    public static var vpMatrix(get, null):Mat4 = Mat4.identity(new Mat4());
    private static function get_vpMatrix():Mat4 {
        if(vpDirty) {
            GLM.orthographic(0, screenWidth, screenHeight, 0, 0, 1, vpMatrix);
            vpDirty = false;
        }
        return vpMatrix;
    }

    public static var buffer(default, null):FloatArray = new FloatArray(8 * 6 * 32);
    public static var numVertices(default, null):Int = 0;

    private static var font:Font;

    private function new() {}

    public static function initialize():Void {
        font = Font.fromFontSrc(fontSrc);
    }

    public static function newFrame():Void {
        numVertices = 0;
    }

    private static function addVertex(x:Float, y:Float, u:Float, v:Float, colour:Vec4):Void {
        var i:Int = numVertices * 8;
        buffer[i + 0] = x;
        buffer[i + 1] = y;
        buffer[i + 2] = u;
        buffer[i + 3] = v;
        buffer[i + 4] = colour.r;
        buffer[i + 5] = colour.g;
        buffer[i + 6] = colour.b;
        buffer[i + 7] = colour.a;
        numVertices++;

        if((numVertices * 8) >= buffer.length) {
            // resize the buffer
            var newBuffer:FloatArray = new FloatArray(buffer.length + (8 * 6 * 32));
            for(i in 0...buffer.length)
                newBuffer[i] = buffer[i];
            buffer = newBuffer;
        }
    }

    public static function drawText(x:Float, y:Float, text:String, ?colour:Vec4):Void {
        if(colour == null) colour = TuskConfig.text_Colour;
        font.print(x, y, text, function(_x:Float, _y:Float, _u:Float, _v:Float):Void {
            addVertex(_x, _y, _u, _v, colour);
        });
    }

    public static function drawWindow(x:Float, y:Float, w:Float, h:Float, title:String):Void {
        // draw the body
        addVertex(x + 0, y + TuskConfig.window_headerHeight, 1, 1, TuskConfig.window_bodyColour);
        addVertex(x + w, y + TuskConfig.window_headerHeight, 1, 1, TuskConfig.window_bodyColour);
        addVertex(x + 0, y + h, 1, 1, TuskConfig.window_bodyColour);

        addVertex(x + 0, y + h, 1, 1, TuskConfig.window_bodyColour);
        addVertex(x + w, y + TuskConfig.window_headerHeight, 1, 1, TuskConfig.window_bodyColour);
        addVertex(x + w, y + h, 1, 1, TuskConfig.window_bodyColour);
        
        // draw the header
        addVertex(x + 0, y + 0, 1, 1, TuskConfig.window_headerColour);
        addVertex(x + w, y + 0, 1, 1, TuskConfig.window_headerColour);
        addVertex(x + 0, y + TuskConfig.window_headerHeight, 1, 1, TuskConfig.window_headerColour);

        addVertex(x + 0, y + TuskConfig.window_headerHeight, 1, 1, TuskConfig.window_headerColour);
        addVertex(x + w, y + 0, 1, 1, TuskConfig.window_headerColour);
        addVertex(x + w, y + TuskConfig.window_headerHeight, 1, 1, TuskConfig.window_headerColour);

        // draw the title over the header
        font.print(x + 2, y + TuskConfig.window_headerHeight - font.descent - 2, title, function(_x:Float, _y:Float, _u:Float, _v:Float):Void {
            addVertex(_x, _y, _u, _v, TuskConfig.window_headerTextColour);
        });
    }
}