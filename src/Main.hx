package;

import mammoth.components.Transform;
import mammoth.Mammoth;

class Main {
    public static function main() {
        trace("woo!");
<<<<<<< HEAD
        Mammoth.init("Patsy", 960, 540, onReady);
    }

    public static function onReady():Void {
        Mammoth.fullscreen = true;
        Mammoth.mouseLocked = true;
        Mammoth.start();
=======
        Mammoth.init("Patsy", onReady);
    }

    private static function onReady():Void {
    	Mammoth.engine.create([
    		new Transform()
    	]);

        Mammoth.begin();
>>>>>>> standalone
    }
}
