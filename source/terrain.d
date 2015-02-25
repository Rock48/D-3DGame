import texture;
import mesh;
import gl3n.linalg;
import std.stdio;

class Terrain {
	private ubyte width;
	
	Mesh mesh;
	
	float[] heightmap;
	
	this(float[] heightmap, ubyte width) {
		this.width = width;
		this.heightmap = heightmap;
		this.mesh = generateTerrain();
	}
	
	private Mesh generateTerrain() {
		int count = width * width;
		Vertex vertices[];
		uint indices[];
		
		vertices.length = count;
		indices.length = 6*(width-1)*(width-1);
		
		for(uint i=0; i<width; i++) {
			for(uint j=0; j<width; j++) {
				uint texX;
				uint texY;
				if(i%2==0){
					texX = 0;
				} else {
					texX = 1;
				}
				if(j%2==0){
					texY = 0;
				} else {
					texY = 1;
				}
				vertices[i + j * width] = Vertex(vec3(i,heightmap[i+j*width],j), vec2(texX,texY));
			}
		}
		
		int pointer = 0;
		for(int i=0;i<width-1;i++){
			for(int j=0;j<width-1;j++){
				int topLeft = (i*width)+j;
				int topRight = topLeft + 1;
				int bottomLeft = ((i+1)*width)+j;
				int bottomRight = bottomLeft + 1;
				indices[pointer++] = topLeft;
				indices[pointer++] = bottomLeft;
				indices[pointer++] = topRight;
				indices[pointer++] = topRight;
				indices[pointer++] = bottomLeft;
				indices[pointer++] = bottomRight;
			}
		}
		
		vertices.writeln;
		indices.writeln;
		
		return new Mesh(vertices, indices);
	}
}