package;

import mammoth.Mammoth;

class Main {
    public static function main() {
        Mammoth.init('Patsy', 960, 540, onReady);
    }

    public static function onReady():Void {
    	Mammoth.fullscreen = true;
    	Mammoth.mouseLocked = true;
        Mammoth.start();
    }
}
