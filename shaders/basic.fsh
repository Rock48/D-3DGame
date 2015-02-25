#version 120

uniform sampler2D diffuse;

varying vec2 texCoord0;
varying vec3 location;

const int LIGHT_AMOUNT = 3;

const vec3 LIGHT_LOCATIONS[LIGHT_AMOUNT] = vec3[](
												vec3(0,2,0),
												vec3(5,1,-5),
												vec3(3,2,-3)
												);
const vec4 LIGHT_COLORS[LIGHT_AMOUNT] = vec4[](
												vec4(174.0/255, 1, 0, 5),
												vec4(0, 1, 1, 3),
												vec4(1, 0, 0, 10)
												);

void main() {vec4(1,1,0,1);
	
	for(int i = 0; i < LIGHT_AMOUNT; i++) {
		float dist = distance(LIGHT_LOCATIONS[i], location);
		float brightness = (1.0 / pow(dist, 2)) * LIGHT_COLORS[i].a;
		
		gl_FragColor += LIGHT_COLORS[i] * brightness;
	}
	
	gl_FragColor = texture2D(diffuse, texCoord0);
}