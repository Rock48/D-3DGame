import texture;
import mesh;
import gl3n.linalg;
import std.stdio;
import std.datetime;
import noise.mod.perlin;

class Terrain {
	private uint width;
	
	Mesh mesh;
	
	float[] heightmap;
	
	this(float[] heightmap, uint width) {
		this.width = width;
		this.heightmap = heightmap;
		this.mesh = generateTerrain();
	}
	
	public static Terrain generateTerrain(uint width) {
		float hm[];
		hm.length = width*width;
		
		Perlin perl = new Perlin();
		
		perl.SetSeed(cast(int)Clock.currSystemTick().msecs());
		
		for(uint i=0; i<width; i++) {
			for(uint j=0; j<width; j++) {
				hm[i + width*j] = 10 * cast(float)perl.GetValue(cast(double)i/100.0,0,cast(double)j/100.0);
			}
		}
		
		return new Terrain(hm, width);
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
		
		return new Mesh(vertices, indices);
	}
}