package mammoth;

import js.Browser;
import js.html.CanvasElement;
import js.html.webgl.RenderingContext;
import mammoth.utilities.Colour;

@:allow(mammoth.Mammoth)
class Graphics {
    public var context:RenderingContext;

    private var halfFloat:Dynamic;
    private var depthTexture:Dynamic;
    private var anisotropicFilter:Dynamic;
    private var drawBuffers:Dynamic;

    private function new() {}

    private function init(title:String, width:Int, height:Int) {
        Browser.document.title = title;

        // create our canvas
        var canvas:CanvasElement = Browser.document.createCanvasElement();
        context = canvas.getContextWebGL({
            alpha: false,
            antialias: false,
            depth: true,
            premultipliedAlpha: true,
            preserveDrawingBuffer: true,
            stencil: true,
        });

        // add the GL extensions
        if(context != null) {
            context.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
            context.getExtension("OES_texture_float");
            context.getExtension("OES_texture_float_linear");
            halfFloat = context.getExtension("OES_texture_half_float");
            context.getExtension("OES_texture_half_float_linear");
            depthTexture = context.getExtension("WEBGL_depth_texture");
            context.getExtension("EXT_shader_texture_lod");
            context.getExtension("OES_standard_derivatives");
            anisotropicFilter = context.getExtension("EXT_texture_filter_anisotropic");
            if(anisotropicFilter == null)
                anisotropicFilter = context.getExtension("WEBKIT_EXT_texture_filter_anisotropic");
            drawBuffers = context.getExtension("WEBGL_draw_buffers");
        }

        // add the canvas to the body
        Browser.document.body.appendChild(canvas);
        context.canvas.width = width;
        context.canvas.height = height;
    }

    inline public function clearColour(colour:Colour)
        context.clearColor(colour.r, colour.g, colour.b, colour.a);

    inline public function enable(cap:Int)
        context.enable(cap);

    inline public function depthFunc(func:Int)
        context.depthFunc(func);

    inline public function clear(mask:Int)
        context.clear(mask);

    inline public function viewport(x:Int, y:Int, w:Int, h:Int)
        context.viewport(x, y, w, h);

    inline public function scissor(x:Int, y:Int, w:Int, h:Int)
        context.scissor(x, y, w, h);
}