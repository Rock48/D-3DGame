#version 120

attribute vec3 position;
attribute vec2 texCoord;

varying vec2 texCoord0;
varying vec3 location;

uniform mat4 transform;
uniform mat4 world;

void main() {
	gl_Position = world * transform * vec4(position, 1.0);
	
	location = (transform * vec4(position, 1.0)).xyz;
	
	texCoord0 = texCoord;
}