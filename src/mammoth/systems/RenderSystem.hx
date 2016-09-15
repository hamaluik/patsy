package mammoth.systems;

import edge.ISystem;
import edge.View;
import mammoth.components.Transform;
import mammoth.components.Camera;
import mammoth.Mammoth;

class RenderSystem implements ISystem {
    public function update(transform:Transform, camera:Camera) {
        // setup the viewport
        var vpX:Int = Std.int(camera.viewportMin.x * Mammoth.width);
        var vpY:Int = Std.int(camera.viewportMin.y * Mammoth.height);
        var vpW:Int = Std.int((camera.viewportMax.x - camera.viewportMin.x) * Mammoth.width);
        var vpH:Int = Std.int((camera.viewportMax.y - camera.viewportMin.y) * Mammoth.height);

        Mammoth.graphics.gl.clearColor(camera.clearColour.r, camera.clearColour.g, camera.clearColour.b, camera.clearColour.a);
        Mammoth.graphics.gl
    }
}
