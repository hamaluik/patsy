package;

import mammoth.Mammoth;

class Main {
    public static function main() {
        trace("woo!");
        Mammoth.init("Patsy", 960, 540, onReady, 60);
    }

    private static function onReady():Void {
        trace("ready!");
    }
}
