import gl3n.linalg;
import std.stdio;
import derelict.opengl3.gl3;

struct Vertex {
	vec3 pos;
	vec2 texCoord;
}

class Mesh {
	
	uint vertexArrayObject;
	uint positionBuffer;
	uint texCoordBuffer;
	uint indexBuffer;
	uint drawCount;
	
	this(Vertex[] vertices, uint[] indices) {
		drawCount = indices.length;
		
		vec3[] positions;
		vec2[] texCoords;
		
		positions.length = vertices.length;
		texCoords.length = vertices.length;
		
		for(uint i = 0; i < vertices.length; i++) {
			positions[i] = vertices[i].pos;
			texCoords[i] = vertices[i].texCoord;
		}
		
		glGenVertexArrays(1, &vertexArrayObject);
		glBindVertexArray(vertexArrayObject);
		
		glGenBuffers(1, &positionBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, positionBuffer);
		glBufferData(GL_ARRAY_BUFFER, vertices.length * vec3.sizeof, positions.ptr, GL_STATIC_DRAW);
		
		glEnableVertexAttribArray(0);
		glVertexAttribPointer(0, 3, GL_FLOAT, false, 0, null);
		
		glGenBuffers(1, &texCoordBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, texCoordBuffer);
		glBufferData(GL_ARRAY_BUFFER, vertices.length * vec2.sizeof, texCoords.ptr, GL_STATIC_DRAW);
		
		glEnableVertexAttribArray(1);
		glVertexAttribPointer(1, 2, GL_FLOAT, false, 0, null);
		
		glGenBuffers(1, &indexBuffer);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length * uint.sizeof, indices.ptr, GL_STATIC_DRAW);
		
		
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