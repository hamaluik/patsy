package mammoth;

import edge.Engine;
import edge.Phase;
import mammoth.Graphics;

class Mammoth {
	// parts of our system
    public static var engine:Engine;
    public static var updatePhase:Phase;
    public static var renderPhase:Phase;

    public static var graphics:Graphics = new Graphics();

    // public timing variables
    public static var time(get, never):Float;
    public static function get_time():Float
        return Timing.time;
    public static var alpha(get, never):Float;
    public static function get_alpha():Float
        return Timing.alpha;

    // public size variables
    public static var width(get, never):Float;
    public static function get_width():Float
        return graphics.gl.canvas.width;
    public static var height(get, never):Float;
    public static function get_height():Float
        return graphics.gl.canvas.height;
    
    public static function init(
            title:String,
            ?onReady:Void->Void,
            updateRate:Float=60):Void {
        // initialize our subsystems
        graphics.init(title);
        Timing.dt = 1 / updateRate;

        // initialize the ECS
        engine = new Engine();
        updatePhase = engine.createPhase();
        renderPhase = engine.createPhase();

        // initialize our rendering
        renderPhase.add(new mammoth.systems.ModelMatrixSystem());
        renderPhase.add(new mammoth.systems.CameraSystem());
        renderPhase.add(new mammoth.systems.RenderSystem());

        if(onReady != null)
            onReady();
    }

    public static function begin() {
        Timing.onUpdate = onUpdate;
        Timing.onRender = onRender;
        Timing.start();
    }

    public static function end() {
        Timing.stop();
    }

    private static function onUpdate(dt:Float):Void {
        updatePhase.update(dt);
    }

    private static function onRender(dt:Float, alpha:Float):Void {
        renderPhase.update(dt);
    }
}
