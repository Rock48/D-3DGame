#version 120

attribute vec3 position;
attribute vec2 texCoord;
attribute vec3 normal;
attribute vec4 texValue;

varying vec2 texCoord0;
varying vec4 texVal;
varying vec3 normal0;

uniform mat4 transform;
uniform mat4 world;

void main() {
	gl_Position = world * transform * vec4(position, 1.0);
	
	texVal = texValue;
	
	texCoord0 = texCoord;
	
	normal0 = ( vec4(normal, 1.0)).xyz;
}