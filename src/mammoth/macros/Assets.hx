package mammoth.macros;

import Sys;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

class Assets {
    private static function copy(sourceDir:String, targetDir:String):Int {
        var numCopied:Int = 0;

        if(!FileSystem.exists(targetDir))
            FileSystem.createDirectory(targetDir);

        for(entry in FileSystem.readDirectory(sourceDir)) {
            var srcFile:String = Path.join([sourceDir, entry]);
            var dstFile:String = Path.join([targetDir, entry]);

            if(FileSystem.isDirectory(srcFile))
                numCopied += copy(srcFile, dstFile);
            else {
                File.copy(srcFile, dstFile);
                numCopied++;
            }
        }
        return numCopied;
    }

    public static function copyProjectAssets() {
        var cwd:String = Sys.getCwd();
        var assetSrcFolder = Path.join([cwd, "src", "assets"]);
        var assetsDstFolder = Path.join([cwd, "bin", "assets"]);

        // make sure the assets folder exists
        if(!FileSystem.exists(assetsDstFolder))
            FileSystem.createDirectory(assetsDstFolder);

        // copy it!
        var numCopied = copy(assetSrcFolder, assetsDstFolder);
        Sys.println('[mammoth] copied ${numCopied} project assets to bin!');
    }

    public static function makeIndex(title:String) {
        var indexFile = Path.join([Sys.getCwd(), "bin", "index.html"]);
        File.saveContent(indexFile, '<html>
    <head>
        <title>${title}</title>
        <style>
            html, body {
                width: 100%;
                height: 100%;
                margin: 0px;
            }
        </style>
    </head>
    <body>
        <script src="game.js"></script>
    </body>
</html>');
    }
}
