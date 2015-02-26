import gl3n.linalg;
import std.stdio;
import derelict.opengl3.gl3;

struct Vertex {
	vec3 pos;
	vec2 texCoord;
	vec3 normal;
}

class Mesh {
	
	uint vertexArrayObject;
	uint positionBuffer;
	uint texCoordBuffer;
	uint indexBuffer;
	uint normalBuffer;
	uint drawCount;
	
	this(Vertex[] vertices, uint[] indices, GLenum drawtype) {
		drawCount = indices.length;
		
		vec3[] positions;
		vec2[] texCoords;
		vec3[] normals;
		
		positions.length = vertices.length;
		texCoords.length = vertices.length;
		normals.length = vertices.length;
		
		for(uint i = 0; i < vertices.length; i++) {
			positions[i] = vertices[i].pos;
			texCoords[i] = vertices[i].texCoord;
			normals[i] = vertices[i].normal;
		}
		
		glGenVertexArrays(1, &vertexArrayObject);
		glBindVertexArray(vertexArrayObject);
		
		glGenBuffers(1, &positionBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, positionBuffer);
		glBufferData(GL_ARRAY_BUFFER, vertices.length * vec3.sizeof, positions.ptr, drawtype);
		
		glEnableVertexAttribArray(0);
		glVertexAttribPointer(0, 3, GL_FLOAT, false, 0, null);
		
		glGenBuffers(1, &texCoordBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, texCoordBuffer);
		glBufferData(GL_ARRAY_BUFFER, vertices.length * vec2.sizeof, texCoords.ptr, drawtype);
		
		glEnableVertexAttribArray(1);
		glVertexAttribPointer(1, 2, GL_FLOAT, false, 0, null);
		
		glGenBuffers(1, &indexBuffer);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length * uint.sizeof, indices.ptr, drawtype);
		
		glGenBuffers(1, &normalBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
		glBufferData(GL_ARRAY_BUFFER, vertices.length * vec3.sizeof, normals.ptr, drawtype);
		
		glEnableVertexAttribArray(2);
		glVertexAttribPointer(2, 3, GL_FLOAT, false, 0, null);
		
		glBindVertexArray(0);
	}
	
	void newVertices(Vertex[] vertices) {
		vec3[] positions;
		vec2[] texCoords;
		vec3[] normals;
		
		positions.length = vertices.length;
		texCoords.length = vertices.length;
		normals.length = vertices.length;
		
		for(uint i = 0; i < vertices.length; i++) {
			positions[i] = vertices[i].pos;
			texCoords[i] = vertices[i].texCoord;
			normals[i] = vertices[i].normal;
		}
		glBindVertexArray(vertexArrayObject);
		glBindBuffer(GL_ARRAY_BUFFER, positionBuffer);
		glBufferData(GL_ARRAY_BUFFER, vertices.length * vec3.sizeof, positions.ptr, GL_DYNAMIC_DRAW);
		glBindBuffer(GL_ARRAY_BUFFER, texCoordBuffer);
		glBufferData(GL_ARRAY_BUFFER, vertices.length * vec2.sizeof, texCoords.ptr, GL_DYNAMIC_DRAW);
		glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
		glBufferData(GL_ARRAY_BUFFER, vertices.length * vec3.sizeof, normals.ptr, GL_DYNAMIC_DRAW);
		glBindVertexArray(0);
		
	}
	
	void draw() {
		glBindVertexArray(vertexArrayObject);
		glDrawElements(GL_TRIANGLES, drawCount, GL_UNSIGNED_INT, null);
		//glDrawArrays(GL_TRIANGLES, 0, drawCount);
		glBindVertexArray(0);
	}
	
	~this() {
		glDeleteVertexArrays(1, &vertexArrayObject);
	}
}