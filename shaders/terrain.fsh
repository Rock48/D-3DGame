#version 120

uniform sampler2D tex1;
uniform sampler2D tex2;
uniform sampler2D tex3;
uniform sampler2D tex4;
uniform vec4 color;

varying vec2 texCoord0;
varying vec4 texVal;
varying vec3 normal0;

const vec3 lightDirection = vec3(0,-0.5,1);

void main() {	
	gl_FragColor = texture2D(tex1, texCoord0) * texVal.x + texture2D(tex2, texCoord0) * texVal.y + texture2D(tex3, texCoord0) * texVal.z + texture2D(tex4, texCoord0) * texVal.a;
	float brightness = clamp(dot(-lightDirection, normal0), 0.0, 1.0);
	gl_FragColor *= color * vec4(brightness, brightness, brightness, 1);
}