import gl3n.linalg;
import app;

class Transform {
	vec3 pos;
	vec3 scale;
	vec3 rot;
	
	this(vec3 pos, vec3 scale, vec3 rot) {
		this.pos = pos;
		this.scale = scale;
		this.rot = rot;
	}
	
	this() {
		pos = vec3(0,0,0);
		scale = vec3(1,1,1);
		rot = vec3(0,0,0);
	}
	
	mat4 getModel() {
		mat4 posMatrix = mat4.translation(pos.x, pos.y, pos.z);
		mat4 rotXMatrix = mat4.rotation(rot.x, vec3(1,0,0));
		mat4 rotYMatrix = mat4.rotation(rot.y, vec3(0,1,0));
		mat4 rotZMatrix = mat4.rotation(rot.z, vec3(0,0,1));
		mat4 scaleMatrix = mat4.scaling(scale.x, scale.y, scale.z);
		
		mat4 rotMatrix = rotZMatrix * rotYMatrix * rotXMatrix;
		
		return posMatrix * rotMatrix * scaleMatrix;
	}
}