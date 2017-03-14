#ifdef GL_ES
precision mediump float;
#endif

// attribute inputs
attribute vec3 position;
#ifdef ATTRIBUTE_NORMAL
attribute vec3 normal;
#endif
#ifdef ATTRIBUTE_UV
attribute vec2 uv;
#endif
#ifdef ATTRIBUTE_COLOUR
attribute vec3 colour;
#endif

// camera uniforms
uniform mat4 MVP;
#ifdef ATTRIBUTE_NORMAL
uniform mat4 M;
#endif

// lights
#ifdef UNIFORM_DIRECTIONAL_LIGHTS
struct SDirectionalLight {
    vec3 direction;
    vec3 colour;
};
uniform SDirectionalLight directionalLights[NUMBER_DIRECTIONAL_LIGHTS];
#endif

// material uniforms
uniform vec3 albedoColour;
#ifdef UNIFORM_AMBIENT
uniform vec3 ambientColour;
#endif

// outputs
varying vec3 v_colour;
#ifdef ATTRIBUTE_UV
varying vec2 v_uv;
#endif

void main() {
    // set the camera-space position of the vertex
	gl_Position = MVP * vec4(position, 1.0);

    #ifdef ATTRIBUTE_NORMAL
	// transform normals into world space
	vec3 worldNormal = (M * vec4(normal, 0.0)).xyz;
    #endif
	
    vec3 colour = albedoColour;
    #ifdef UNIFORM_DIRECTIONAL_LIGHTS
	// sun diffuse term
	float dLight0 = clamp(dot(worldNormal, directionalLights[0].direction), 0.0, 1.0);
    colour *= directionalLights[0].colour * dLight0;
    #endif

    #ifdef UNIFORM_AMBIENT
	// add some ambient
	colour += albedoColour * ambientColour;
    #endif

    v_colour = colour;
    #ifdef ATTRIBUTE_UV
	// interpolate the UV
	v_uv = uv;
    #endif
}