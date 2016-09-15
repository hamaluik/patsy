package;

import glm.Vec2;
import mammoth.components.Camera;
import mammoth.components.Transform;
import mammoth.Mammoth;
import mammoth.utilities.Colour;

class Main {
    public static function main() {
        Mammoth.init("Patsy", onReady);
    }

    private static function onReady():Void {
    	Mammoth.engine.create([
    		new Transform(),
    		new Camera()
    			.setNearFar(0.1, 100)
    			.setProjection(ProjectionMode.Perspective(49.1343421))
    			.setViewport(new Vec2(0, 0), new Vec2(1, 1))
    			.setClearColour(new Colour(1, 0, 0))
    	]);

        Mammoth.begin();
    }
}
