#version 120

uniform sampler2D diffuse;
uniform vec4 color;

varying vec2 texCoord0;
varying vec3 normal0;

const vec3 lightDirection = vec3(0,-1,1);

void main() {	
	gl_FragColor = texture2D(diffuse, texCoord0);
	float brightness = clamp(dot(-lightDirection, normal0), 0.0, 1.0);
	gl_FragColor *= color * vec4(brightness, brightness, brightness, 1);
	
}