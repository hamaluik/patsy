package mammoth.systems;

import edge.ISystem;
import edge.View;
import mammoth.components.MeshRenderer;
import mammoth.components.Transform;
import mammoth.components.Camera;
import mammoth.Mammoth;
import mammoth.Graphics;
import mammoth.GL;
import mammoth.render.Material;

class RenderSystem implements ISystem {
    var objects:View<{ transform:Transform, renderer:MeshRenderer }>;

    public function update(transform:Transform, camera:Camera) {
        // calculate the viewport
        var vpX:Int = Std.int(camera.viewportMin.x * Mammoth.width);
        var vpY:Int = Std.int(camera.viewportMin.y * Mammoth.height);
        var vpW:Int = Std.int((camera.viewportMax.x - camera.viewportMin.x) * Mammoth.width);
        var vpH:Int = Std.int((camera.viewportMax.y - camera.viewportMin.y) * Mammoth.height);

        // clear our region of the screen
        var g:Graphics = Mammoth.graphics;
        g.context.viewport(vpX, vpY, vpW, vpH);
        g.context.scissor(vpX, vpY, vpW, vpH);
        g.clearColour(camera.clearColour);
        g.context.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);

        // render each object!
        for(o in objects) {
            var material:Material = o.data.renderer.material;

            // TODO: set the MVP uniforms
            
            // TODO: lighting?
            
            // apply the material and render!
            material.apply();
            // bindBuffers()
            // drawIndexedVertices()
        }
    }
}
