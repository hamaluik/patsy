/*
 * Copyright (c) 2017 Kenton Hamaluik
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *     http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/
package mammoth;

import edge.Engine;
import edge.Phase;
import mammoth.Graphics;
import mammoth.debug.DebugView;
import mammoth.macros.Defines;
import tusk.Tusk;

class Mammoth {
	// parts of our system
    public static var engine:Engine;
    public static var preUpdatePhase:Phase;
    public static var updatePhase:Phase;
    public static var postUpdatePhase:Phase;
    public static var renderPhase:Phase;

    public static var graphics:Graphics = new Graphics();
    private static var debugView:DebugView;

    // public timing variables
    public static var time(get, never):Float;
    private inline static function get_time():Float return Timing.time;
    public static var alpha(get, never):Float;
    private inline static function get_alpha():Float return Timing.alpha;

    // public size variables
    public static var width(get, never):Float;
    private inline static function get_width():Float return graphics.width;
    public static var height(get, never):Float;
    private inline static function get_height():Float return graphics.height;

    static macro function getDefine(key:String):Expr return macro $v{Context.definedValue(key)};
    static macro function isDefined(key:String):Expr return macro $v{Context.defined(key)};
    
    public static function init(title:String, ?onReady:Void->Void, updateRate:Float=60):Void {
        var width:Int = Defines.isDefined("window.width") ? Std.parseInt(Defines.getDefine("window.width")) : 960;
        var height:Int = Defines.isDefined("window.height") ? Std.parseInt(Defines.getDefine("window.height")) : 540;

        // initialize our subsystems
        graphics.init(title, width, height);
        if(Defines.isDefined("window.full"))
            graphics.fullWindow(true);
        
        debugView = new DebugView();

        // calculate the clock period
        Timing.dt = 1 / updateRate;

        // initialize the ECS
        engine = new Engine();
        preUpdatePhase = engine.createPhase();
        updatePhase = engine.createPhase();
        postUpdatePhase = engine.createPhase();
        renderPhase = engine.createPhase();

        // initialize our pre- and post- systems
        preUpdatePhase.add(new mammoth.systems.PreTransformSystem());

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
        preUpdatePhase.update(dt);
        updatePhase.update(dt);
        postUpdatePhase.update(dt);

        Tusk.newFrame();
        Tusk.drawWindow((width - 200) / 2, (height - 100) / 2, 200, 100, 'Derp');
    }

    private static function onRender(dt:Float, alpha:Float):Void {
        renderPhase.update(dt);
        debugView.draw();
    }
}
