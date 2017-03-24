#ifdef GL_ES
precision mediump float;
#endif

// attribute inputs
attribute vec3 position;
attribute vec3 normal;

#ifdef ATTRIBUTE_UV
attribute vec2 uv;
#endif
#ifdef ATTRIBUTE_COLOUR
attribute vec3 colour;
#endif

// camera uniforms
uniform mat4 MVP;
uniform mat4 M;

// lights
#ifdef UNIFORM_DIRECTIONAL_LIGHTS
struct SDirectionalLight {
    vec3 direction;
    vec3 colour;
};
uniform SDirectionalLight directionalLights[NUMBER_DIRECTIONAL_LIGHTS];
#endif
#ifdef UNIFORM_POINT_LIGHTS
struct SPointLight {
    vec3 position;
    vec3 colour;
};
uniform SPointLight pointLights[NUMBER_POINT_LIGHTS];
#endif

// material uniforms
uniform vec3 albedoColour;
uniform vec3 ambientColour;

// outputs
varying vec3 v_colour;
#ifdef ATTRIBUTE_UV
varying vec2 v_uv;
#endif

void main() {
    // transform position to world space
    vec3 worldPosition = (M * vec4(position, 1.0)).xyz;

	// transform normals into world space
	vec3 worldNormal = (M * vec4(normal, 0.0)).xyz;
	
    vec3 colour = albedoColour * ambientColour;

    #ifdef UNIFORM_DIRECTIONAL_LIGHTS
	// sun diffuse term
	float dLight0 = clamp(dot(worldNormal, directionalLights[0].direction), 0.0, 1.0);
    colour += directionalLights[0].colour * dLight0 * albedoColour;
    #endif

    #ifdef UNIFORM_POINT_LIGHTS
    vec3 pLightDir0 = pointLights[0].position - worldPosition;
    float pDist0 = length(pLightDir0);
	float pLight0 = clamp(dot(worldNormal, pLightDir0), 0.0, 1.0) / (pDist0 * pDist0);
    colour += pointLights[0].colour * pLight0 * albedoColour;
    #endif

    v_colour = colour;
    #ifdef ATTRIBUTE_UV
	v_uv = uv;
    #endif

    // set the camera-space position of the vertex
	gl_Position = MVP * vec4(position, 1.0);
}