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
	uint drawCount;
	
	this(Vertex[] vertices) {
		drawCount = vertices.length;
		
		vec3[] positions;
		vec2[] texCoords;
		
		positions.length = drawCount;
		texCoords.length = drawCount;
		
		for(uint i = 0; i < drawCount; i++) {
			positions[i] = vertices[i].pos;
			texCoords[i] = vertices[i].texCoord;
		}
		
		glGenVertexArrays(1, &vertexArrayObject);
		glBindVertexArray(vertexArrayObject);
		
		glGenBuffers(1, &positionBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, positionBuffer);
		glBufferData(GL_ARRAY_BUFFER, drawCount * vec3.sizeof, positions.ptr, GL_STATIC_DRAW);
		
		glEnableVertexAttribArray(0);
		glVertexAttribPointer(0, 3, GL_FLOAT, false, 0, null);
		
		glGenBuffers(1, &texCoordBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, texCoordBuffer);
		glBufferData(GL_ARRAY_BUFFER, drawCount * vec2.sizeof, texCoords.ptr, GL_STATIC_DRAW);
		
		glEnableVertexAttribArray(1);
		glVertexAttribPointer(1, 2, GL_FLOAT, false, 0, null);
		
		glBindVertexArray(0);
	}
	
	void draw() {
		glBindVertexArray(vertexArrayObject);
		glDrawArrays(GL_TRIANGLES, 0, drawCount);
		glBindVertexArray(0);
	}
	
	~this() {
		glDeleteVertexArrays(1, &vertexArrayObject);
	}
}