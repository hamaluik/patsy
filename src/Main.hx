package;

import glm.Quat;
import glm.Vec2;
import haxe.io.Bytes;
import mammoth.Assets;
import mammoth.components.Camera;
import mammoth.components.MeshRenderer;
import mammoth.components.Transform;
import mammoth.Mammoth;
import mammoth.render.Material;
import mammoth.render.TUniform;
import mammoth.utilities.Colour;
import gltf.GLTF;

class Main {
    public static function main() {
        Mammoth.init("Patsy", onReady);
    }

    private static function onReady():Void {
    	Mammoth.engine.create([
    		new Transform()
                .setPosition(2.1810226, -4.74123, 2.361527)
                .setRotation(new Quat(0.5776544, 0.1232913, 0.1594744, 0.7910011)),
    		new Camera()
    			.setNearFar(0.1, 100)
    			.setProjection(ProjectionMode.Perspective(49.1343421))
    			.setViewport(new Vec2(0, 0), new Vec2(1, 1))
    			.setClearColour(Colour.Black)
    	]);

        var vertex:String = '
            attribute vec2 position;
            void main() {
                gl_Position = vec4(position, 0, 1);
            }';
        var fragment:String = '
            precision mediump float;
            uniform vec2 canvasSize;
            void main() {
                // Set this pixel\'s color to a gradient from black to green across the canvas.
                // Color values in shaders go from [0 -> 1].
                gl_FragColor = vec4(0, gl_FragCoord.x / canvasSize[0] * 1.0, 0, 1);
            }';

        Mammoth.engine.create([
            new Transform()
                .setPosition(0, 0, 1.1864519)
                .setRotation(new Quat(0, 0, 0.383734, 0.9234437))
                .setScale(1, 1, 1),
            new MeshRenderer()
                //.setMesh(Primitives.cube(true, true, true))
                .setMaterial(new Material("cube", Mammoth.graphics)
                    .setVertexShader(vertex)
                    .setFragmentShader(fragment)
                    .compile()
                    .setUniform("canvasSize", TUniform.Float2(Mammoth.width, Mammoth.height)))
        ]);

        Mammoth.begin();
    }
}
