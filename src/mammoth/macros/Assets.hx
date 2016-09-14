package mammoth.macros;

import Sys;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

class Assets {
    public static function clean() {
        var cwd:String = Sys.getCwd();
        var binFolder = Path.join([cwd, "bin"]);
        var numRemoved:UInt = 0;
        var files:Array<String> = FileSystem.readDirectory(binFolder);
        for(f in files) {
            var file:String = Path.join([binFolder, f]);
            FileSystem.deleteFile(file);
            numRemoved++;
        }

        trace('Removed ${numRemoved} files from bin!');
    }

    public static function buildAssets() {
        var cwd:String = Sys.getCwd();
        var assetFolder = Path.join([cwd, "assets", "final"]);
        var binFolder = Path.join([cwd, "bin"]);
        var finalAssets:Array<String> = FileSystem.readDirectory(assetFolder);
        var numCopied:UInt = 0;

        for(asset in finalAssets) {
            var src:String = Path.join([assetFolder, asset]);
            var dest:String = Path.join([binFolder, asset]);
            File.copy(src, dest);
            numCopied++;
        }

        trace('Copied ${numCopied} asset files!');
    }
}
