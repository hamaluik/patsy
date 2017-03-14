#ifdef GL_ES
precision mediump float;
#endif

// inputs
varying vec3 v_colour;
#ifdef ATTRIBUTE_UV
varying vec2 v_uv;
#endif

#ifdef UNIFORM_TEXTURE
uniform sampler2D texture;
#endif

void main() {
    vec4 colour = vec4(v_colour, 1.0);
    #ifdef UNIFORM_TEXTURE
    colour *= texture2D(texture, v_uv);
    #endif
    gl_FragColor = colour;
}