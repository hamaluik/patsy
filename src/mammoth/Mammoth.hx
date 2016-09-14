package mammoth;

import js.Browser;
import js.html.CanvasElement;
import js.html.webgl.RenderingContext;
import js.html.webgl.GL;

class Mammoth {
    private static var gl:RenderingContext;

    private static var halfFloat:Dynamic;
    private static var depthTexture:Dynamic;
    private static var anisotropicFilter:Dynamic;
    private static var drawBuffers:Dynamic;

    public static function init(
            title:String,
            ?onReady:Int->Int->Void,
            updateRate:Float=60):Void {
        initContext();
        Browser.document.title = title;
        gl.canvas.width = Browser.window.innerWidth;
        gl.canvas.height = Browser.window.innerHeight;

        onReady(gl.canvas.width, gl.canvas.height);
    }

    private static function initContext() {
        var canvas:CanvasElement = Browser.document.createCanvasElement();
        gl = canvas.getContextWebGL({
            alpha: false,
            antialias: false,
            depth: true,
            premultipliedAlpha: true,
            preserveDrawingBuffer: true,
            stencil: true,
        });

        if(gl != null) {
            gl.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
            gl.getExtension("OES_texture_float");
            gl.getExtension("OES_texture_float_linear");
            halfFloat = gl.getExtension("OES_texture_half_float");
            gl.getExtension("OES_texture_half_float_linear");
            depthTexture = gl.getExtension("WEBGL_depth_texture");
            gl.getExtension("EXT_shader_texture_lod");
            gl.getExtension("OES_standard_derivatives");
            anisotropicFilter = gl.getExtension("EXT_texture_filter_anisotropic");
            if(anisotropicFilter == null)
                anisotropicFilter = gl.getExtension("WEBKIT_EXT_texture_filter_anisotropic");
            drawBuffers = gl.getExtension("WEBGL_draw_buffers");
        }

        Browser.document.body.appendChild(canvas);
    }

    private static function onUpdate(dt:Float):Void {
        // TODO
        trace('update, dt: ${dt}');
    }

    private static function onRender(dt:Float, alpha:Float):Void {
        // TODO
        trace('render, dt: ${dt}, alpha: ${alpha}');
    }

    public static function begin() {
        Timing.onUpdate = onUpdate;
        Timing.onRender = onRender;
        Timing.start();
    }

    public static function end() {
        Timing.stop();
    }
}
