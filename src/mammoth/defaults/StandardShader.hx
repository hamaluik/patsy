package mammoth.defaults;

import haxe.EnumFlags;

enum StandardAttributes {
    Normal;
    UV;
    Colour;
}

enum StandardUniforms {
    DirectionalLights;
    AmbientColour;
    Texture;
}

class StandardShader {
    private var built:Bool = false;
    private var attributes:EnumFlags<StandardAttributes> = new EnumFlags<StandardAttributes>();
    private var uniforms:EnumFlags<StandardUniforms> = new EnumFlags<StandardUniforms>();

    public var vertex(get, null):String = "";
    public function get_vertex():String {
        if(!built) build();
        return vertex;
    }

    public var fragment(get, null):String = "";
    public function get_fragment():String {
        if(!built) build();
        return fragment;
    }

    private static var vertexStandard:String = mammoth.macros.StandardShader.source("vert");
    private static var fragmentStandard:String = mammoth.macros.StandardShader.source("frag");

    public function new() {}

    private function build():Void {
        var prepends:Array<String> = new Array<String>();

        if(attributes.has(StandardAttributes.Normal)) {
            prepends.push('#define ATTRIBUTE_NORMAL');
        }
        if(attributes.has(StandardAttributes.UV)) {
            prepends.push('#define ATTRIBUTE_NORMAL');
        }
        if(attributes.has(StandardAttributes.Colour)) {
            prepends.push('#define ATTRIBUTE_COLOUR');
        }
        if(uniforms.has(StandardUniforms.DirectionalLights)) {
            prepends.push('#define UNIFORM_DIRECTIONAL_LIGHTS');
            prepends.push('#define NUMBER_DIRECTIONAL_LIGHTS 1');
        }
        if(uniforms.has(StandardUniforms.AmbientColour)) {
            prepends.push('#define UNIFORM_AMBIENT');
        }
        if(uniforms.has(StandardUniforms.Texture)) {
            prepends.push('#define UNIFORM_TEXTURE');
        }

        var pre:String = prepends.join('\n');
        vertex = pre + '\n\n' + vertexStandard;
        fragment = pre + '\n\n' + fragmentStandard;

        built = true;
    }

    public function setAttribute(attribute:StandardAttributes):StandardShader {
        attributes.set(attribute);
        built = false;
        return this;
    }

    public function unsetAttribute(attribute:StandardAttributes):StandardShader {
        attributes.unset(attribute);
        built = false;
        return this;
    }

    public function hasAttribute(attribute:StandardAttributes):Bool {
        return attributes.has(attribute);
    }

    public function setUniform(uniform:StandardUniforms):StandardShader {
        uniforms.set(uniform);
        built = false;
        return this;
    }

    public function unsetUniform(uniform:StandardUniforms):StandardShader {
        uniforms.unset(uniform);
        built = false;
        return this;
    }

    public function hasUniform(uniform:StandardUniforms):Bool {
        return uniforms.has(uniform);
    }
}