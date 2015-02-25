import gl3n.linalg;

class Camera {
	mat4 perspective;
	vec3 position;
	vec3 forward;
	vec3 up;
	
	this(vec3 pos, float fov, float width, float height, float zNear, float zFar) {
		perspective = mat4.perspective(width, height, fov, zNear, zFar);
		this.position = pos;
		this.forward = vec3(0,0,1);
		this.up = vec3(0,1,0);
	}
	
	mat4 getViewProjection() const {
		return perspective * mat4.look_at(position, position + forward, up);
	}
	
	void moveForward(float amount) {
		position += forward * amount;
	}
	
	void moveLeft(float amount) {
		position += cross(up, forward) * amount;
	}
	
	void pitch(float angle) {
		vec3 right = cross(up, forward).normalized;
		
		forward = vec3((mat4.rotation(angle, right) * vec4(forward, 0)).normalized);
		up = cross(forward, right).normalized;
	}
	
	void rotateY(float angle) {
		mat4 rotation = mat4.rotation(angle, vec3(0,1,0));
		
		forward = vec3((rotation * vec4(forward, 0)).normalized);
		up = vec3((rotation * vec4(up, 0)).normalized);
	}
}