package mammoth;

import js.Browser;
import js.html.CanvasElement;
import js.html.webgl.RenderingContext;
import js.html.webgl.GL;

@:allow(mammoth.Mammoth)
class Graphics {
    public var context:RenderingContext;
    public var gl:js.html.webgl.GL;

    public var halfFloat:Dynamic;
    public var depthTexture:Dynamic;
    public var anisotropicFilter:Dynamic;
    public var drawBuffers:Dynamic;

    private function init(title:String) {
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
        context.canvas.width = Browser.window.innerWidth;
        context.canvas.height = Browser.window.innerHeight;
    }
}