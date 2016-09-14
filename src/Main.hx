package;

import mammoth.Mammoth;

class Main {
    public static function main() {
        trace("woo!");
        Mammoth.init("Patsy", onReady, 60);
    }

    private static function onReady(?width:Int, ?height:Int):Void {
        trace('ready! ${width}x${height}');
        Mammoth.begin();
    }
}
