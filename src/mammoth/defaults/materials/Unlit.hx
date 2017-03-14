package mammoth.defaults.materials;

import haxe.EnumFlags;

enum CommonAttributes {
    Position;
    Normal;
    UV;
    Colour;
}

class Unlit {
    private var built:Bool = false;
    public var vertex(get, null):String = '';
    public var fragment(get, null):String = '';

    private var attributes:EnumFlags<CommonAttributes> = new EnumFlags<CommonAttributes>();

    public function get_vertex():String {
        if(!built) build();
        return vertex;
    }

    public function get_fragment():String {
        if(!built) build();
        return fragment;
    }

    public function new() {}

    public function has(attribute:CommonAttributes):Bool {
        return attributes.has(attribute);
    }

    public function set(attribute:CommonAttributes):Unlit {
        attributes.set(attribute);
        return this;
    }

    public function unset(attribute:CommonAttributes):Unlit {
        attributes.unset(attribute);
        return this;
    }

    public function build():Void {
        if(built) return;
        vertex = '
            #ifdef GL_ES
            precision mediump float;
            #endif
            ';
        fragment = '
            #ifdef GL_ES
            precision mediump float;
            #endif
            ';

        buildVertex();
        buildFragment();
    }

    private function buildVertex() {
        // inputs
        if(attributes.has(CommonAttributes.Position)) {
            vertex += 'attribute vec3 position;\n';
        }
        if(attributes.has(CommonAttributes.Normal)) {
            vertex += 'attribute vec3 normal;\n';
        }
        if(attributes.has(CommonAttributes.UV)) {
            vertex += 'attribute vec2 uv;\n';
        }
        if(attributes.has(CommonAttributes.Colour)) {
            vertex += 'attribute vec4 colour;\n';
        }

        // camera uniforms
        vertex += 'uniform mat4 MVP;\n';

        // material uniforms

        // outputs

        vertex += 'void main() {\n';
        vertex += '\tgl_Position = MVP * vec4(pos, 1.0);';
        vertex += '}\n';
    }

    private function buildFragment() {

    }
}