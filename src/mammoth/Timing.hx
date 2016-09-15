package mammoth;

import js.Browser;

@:allow(mammoth.Mammoth)
class Timing {
    private static var animationFrameID:Int = 0;
    private static var time:Float = 0;
    private static var lastTime:Float = 0;
    private static var accumulator:Float = 0;

    private static var dt:Float = 1 / 30;
    private static var alpha:Float = 0;

    private static var onUpdate:Float->Void;
    private static var onRender:Float->Float->Void;

    private static function onRenderFrame(ts:Float):Void {
        time = ts / 1000;

        // figure out how long since we last ran
        var delta:Float = time - lastTime;
        lastTime = time;

        // updates
        accumulator += delta;
        while(accumulator >= dt) {
            onUpdate(dt);
            accumulator -= dt;
        }

        // renders
        alpha = accumulator / dt;
        onRender(delta, alpha);

        // go on to the next frame
        requestFrame();
    }

    private static inline function requestFrame() {
        animationFrameID = Browser.window.requestAnimationFrame(onRenderFrame);
    }

    private static function start() {
        requestFrame();
    }

    private static function stop() {
        Browser.window.cancelAnimationFrame(animationFrameID);
    }
}