package;

import mammoth.Mammoth;

class Main {
    public static function main() {
        trace("woo!");
        Mammoth.init("Patsy", onReady, 60);
    }

    public static function onReady():Void {
    	Mammoth.fullscreen = true;
    	Mammoth.mouseLocked = true;
        Mammoth.start();
    }
}
