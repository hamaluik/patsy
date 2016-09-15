package;

import mammoth.components.Transform;
import mammoth.Mammoth;

class Main {
    public static function main() {
        Mammoth.init("Patsy", 960, 540, onReady);
    }

    private static function onReady():Void {
    	Mammoth.engine.create([
    		new Transform()
    	]);

        Mammoth.begin();
    }
}
