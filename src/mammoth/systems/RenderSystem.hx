package mammoth.systems;

import edge.ISystem;
import edge.View;
import mammoth.components.Transform;
import mammoth.components.Camera;
import mammoth.Mammoth;
import mammoth.Graphics;
import mammoth.GL;

class RenderSystem implements ISystem {
    public function update(transform:Transform, camera:Camera) {
        // setup the viewport
        var vpX:Int = Std.int(camera.viewportMin.x * Mammoth.width);
        var vpY:Int = Std.int(camera.viewportMin.y * Mammoth.height);
        var vpW:Int = Std.int((camera.viewportMax.x - camera.viewportMin.x) * Mammoth.width);
        var vpH:Int = Std.int((camera.viewportMax.y - camera.viewportMin.y) * Mammoth.height);

        var g:Graphics = Mammoth.graphics;
        g.enable(GL.DEPTH_TEST);
        g.enable(GL.SCISSOR_TEST);

        g.viewport(vpX, vpY, vpW, vpH);
        g.scissor(vpX, vpY, vpW, vpH);

        g.depthFunc(GL.LEQUAL);

        g.clearColour(camera.clearColour);
        g.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
    }
}
