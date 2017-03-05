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
package mammoth.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import Sys;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

using StringTools;

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

    public static function buildAssetList():Array<Field> {
        var fields:Array<Field> = Context.getBuildFields();

        var assetSrcFolder = Path.join([Sys.getCwd(), "src", "assets"]);
        var files:Array<String> = listFiles(assetSrcFolder);

        // add the fields to the class
        for(file in files) {
            var relativePath:String = file.substr(assetSrcFolder.length + 1);
            var name:String = "asset___" + relativePath.split("/").join("___").split("-").join("_").split(".").join("__");
            relativePath = "assets/" + relativePath;

            fields.push({
                name: name,
                doc: relativePath,
                access: [Access.APublic, Access.AStatic, Access.AInline],
                pos: Context.currentPos(),
                kind: FieldType.FVar(macro: String, macro $v{relativePath})
            });
        }

        return fields;
    }

    public static function listFiles(directory:String):Array<String> {
        var files:Array<String> = new Array<String>();
        for(f in FileSystem.readDirectory(directory)) {
            var file:String = Path.join([directory, f]);
            if(FileSystem.isDirectory(file))
                files = files.concat(listFiles(directory));
            else
                files.push(file);
        }
        return files;
    }
}