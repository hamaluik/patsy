package;

import mammoth.components.Transform;
import mammoth.Mammoth;

class Main {
    public static function main() {
        trace("woo!");
        Mammoth.init("Patsy", onReady);
    }

    private static function onReady():Void {
    	Mammoth.engine.create([
    		new Transform()
    	]);

        Mammoth.begin();
    }
}
