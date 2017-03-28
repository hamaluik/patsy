package tusk.text;

import haxe.ds.IntMap;
import haxe.Json;

class Font {
    public var glyphs:IntMap<Glyph> = new IntMap<Glyph>();

    public var base(default, null):Float;
    public var lineHeight(default, null):Float;
    public var spaceWidth(default, null):Float;
    public var ascent(default, null):Float;
    public var descent(default, null):Float;

    private var unknownGlyph:Glyph;

    public static function fromFontSrc(src:String):Font {
        return new Font(Json.parse(src));
    }

    public function new(bmFont:BMFont) {
        base = bmFont.common.base;
        lineHeight = bmFont.common.lineHeight;
        descent = lineHeight - base;
        ascent = 0;

        var imSize:Vec2 = new Vec2(bmFont.common.scaleW, bmFont.common.scaleH);
        for(char in bmFont.chars) {
            var g:Glyph = new Glyph(char, imSize);
            glyphs.set(char.id, g);

            // find the maximum ascent
            var a:Float = base - g.size.y;
            if(a > ascent) {
                ascent = a;
            }
        }

        unknownGlyph = glyphs.get('?'.charCodeAt(0));
        spaceWidth = glyphs.get(' '.charCodeAt(0)).xAdvance;
    }

    public function print(x:Float, y:Float, text:String, addVertex:AddVertexFunc):Void {
        var _x:Float = x;
        var _y:Float = y;

        for(i in 0...text.length) {
            var idx:Int = text.charCodeAt(i);
            if(idx == null) continue;

            // deal with special characters
            if(idx == ' '.charCodeAt(0)) {
                _x += spaceWidth;
                continue;
            }
            else if(idx == '\n'.charCodeAt(0)) {
                _x = x;
                _y += lineHeight;
                continue;
            }
            else if(idx == '\r'.charCodeAt(0)) {
                _x = x;
                continue;
            }
            else if(idx == '\t'.charCodeAt(0)) {
                _x += (spaceWidth * 4);
                continue;
            }

            // draw a glyph
            var g:Glyph = glyphs.get(idx);
            if(g == null) g = unknownGlyph;

            var x0:Float = _x + g.offset.x;
            var x1:Float = x0 + g.size.x;
            var y0:Float = _y + g.offset.y - base;
            var y1:Float = y0 + g.size.y;

            addVertex(x0, y0, g.uvMin.x, g.uvMin.y);
            addVertex(x1, y0, g.uvMax.x, g.uvMin.y);
            addVertex(x0, y1, g.uvMin.x, g.uvMax.y);

            addVertex(x0, y1, g.uvMin.x, g.uvMax.y);
            addVertex(x1, y0, g.uvMax.x, g.uvMin.y);
            addVertex(x1, y1, g.uvMax.x, g.uvMax.y);

            _x += g.xAdvance;
        }
    }
}