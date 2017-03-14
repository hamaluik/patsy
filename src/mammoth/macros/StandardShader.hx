package mammoth.macros;

import haxe.macro.Expr;
import haxe.io.Path;

class StandardShader {
    macro public static function source(type:String):ExprOf<String> {
        var filename:String = 'standard.${type}.glsl';

        #if sys
        var assetSrcFolder:String = Path.join([Sys.getCwd(), "src", "assets"]);
        #else
        var assetSrcFolder:String = Path.join(["src", "assets"]);
        #end

        var source:String = sys.io.File.getContent(Path.join([assetSrcFolder, filename]));
        return macro $v{source};
    }
}