package mammoth;

import mammoth.Mammoth;
import js.html.MouseEvent;
import js.html.DOMRect;

class Input {
    public var mouseX(default, null):Float = 0;
    public var mouseY(default, null):Float = 0;
    public var mouseDown(default, null):Bool = false;

    public function new() {}

    public function init():Void {
        Mammoth.graphics.context.canvas.addEventListener('mousemove', updateMousePosition);
        Mammoth.graphics.context.canvas.addEventListener('mousedown', updateMouseDown);
        Mammoth.graphics.context.canvas.addEventListener('mouseup', updateMouseUp);
    }

    private function updateMousePosition(evt:MouseEvent):Void {
        var rect:DOMRect = Mammoth.graphics.context.canvas.getBoundingClientRect();
        mouseX = Math.ffloor((evt.clientX - rect.left) / (rect.right - rect.left) * Mammoth.graphics.context.canvas.width);
        mouseY = Math.ffloor((evt.clientY - rect.top) / (rect.bottom - rect.top) * Mammoth.graphics.context.canvas.height);
    }

    private function updateMouseDown(evt:MouseEvent):Void {
        if(evt.button == 0) mouseDown = true;
    }

    private function updateMouseUp(evt:MouseEvent):Void {
        if(evt.button == 0) mouseDown = false;
    }
}