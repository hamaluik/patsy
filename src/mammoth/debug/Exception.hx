package mammoth.debug;

import haxe.CallStack;
import haxe.PosInfos;

class Exception {
	public var message(default, null):String;
	public var type(default, null):String;
	public var fatal(default, null):Bool;
	public var stack(default, null):Array<StackItem>;
	public var showStackTrace(default, null):Bool;
	public var pos(default, null):PosInfos;

	public function new(message:String = '', fatal:Bool = false, type:String = '', showStackTrace:Bool = true, ?pos:PosInfos) {
		this.message = message;
		this.fatal = fatal;
		this.type = type;
		this.showStackTrace = showStackTrace;
		this.stack = CallStack.callStack();
		this.pos = pos;
	}

	private function translateStackItem(item:StackItem):String {
		return switch(item) {
			case CFunction: "in function";
			case Module(m): "in module " + m;
			case FilePos(s, file, line): "in file '" + file + "' at line " + line + (s == null ? "" : (": " + translateStackItem(s)));
			case Method(className, method): "in class '" + className + "' in method '" + method + "'";
			case LocalFunction(v): "in local function (" + v + ")";
			default: "?";
		};
	}

	public function toString():String {
		var stackString:Array<String> = stack.map(translateStackItem);
		var posInfo:String = pos == null ? "" : (" in class: " + pos.className + " (" + pos.fileName + ") in function " + pos.methodName + "() at line " + pos.lineNumber);
		return (fatal ? "fatal " : "") + type + " exception" + posInfo + ": " + message + (showStackTrace ? ("\nstack trace:\n  " + stackString.join("\n  ")) : '');
	}
}