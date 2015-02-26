import texture;
import mesh;
import gl3n.linalg;
import std.stdio;
import std.datetime;
import noise.mod.perlin;
import noise.mod.simplex;
import noise.mod.spheres;
import noise.mod.cylinders;
import noise.mod.multiply;
import derelict.opengl3.gl3;

class Terrain {
	private uint width;
	
	Mesh mesh;
	
	float[] heightmap;
	
	uint textureMapBuffer;
	Perlin perl;
	Simplex simpl;
	Spheres sph;
	Cylinders cyl;
	Multiply multiply;
	
	vec4[] texturemap;
	
	Vertex[] vertices;
	
	this(float[] heightmap, uint width, vec4[] vertTextures) {
		this.width = width;
		this.heightmap = heightmap;
		this.mesh = generateTerrain();
		
		glBindVertexArray(mesh.vertexArrayObject);
		
		glGenBuffers(1, &textureMapBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, textureMapBuffer);
		glBufferData(GL_ARRAY_BUFFER, vertTextures.length * vec4.sizeof, vertTextures.ptr, GL_DYNAMIC_DRAW);
		
		glEnableVertexAttribArray(3);
		glVertexAttribPointer(3, 4, GL_FLOAT, false, 0, null);
		
		glBindVertexArray(0);
		
		perl = new Perlin();
		perl.SetSeed(cast(int)Clock.currSystemTick().msecs());
		simpl = new Simplex();
		simpl.SetSeed(cast(int)Clock.currSystemTick().msecs());
		sph = new Spheres();
		//sph.SetSeed(cast(int)Clock.currSyste
		simpl.SetFrequency(0.1);
		multiply = new Multiply();
				multiply.SetSourceMod(0, &simpl);
				multiply.SetSourceMod(1, &sph);
	}
	
	public void regenerate(float t, float scale) {
		float hm[];
		vec4 tm[];
		hm.length = tm.length = vertices.length = width*width;
		
		for(uint i=0; i<width; i++) {
			for(uint j=0; j<width; j++) {
				uint index = i + width * j;
				
				hm[index] = scale * multiply.GetValue(cast(double)i*6,t/3,cast(double)j*6);
				if(hm[index] <= -1) {
					tm[index] = vec4(0,1,0,0);
				} else {
					tm[index] = vec4(1,0,0,0);
				}
			}
		}
		
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
				float x = cast(float)i - width/2.0;
				float y = cast(float)j - width/2.0;
				
				float heightL = heightmap[i-1+j*width < 0 || i-1+j*width >= width*width ? (i+j*width) : (i-1+j*width)];
				float heightR = heightmap[i+1+j*width < 0 || i+1+j*width >= width*width ? (i+j*width) : (i+1+j*width)];
				float heightD = heightmap[(i+(j-1)*width) < 0 || i+(j-1)*width >= width*width ? (i+j*width) : (i+(j-1)*width)];
				float heightU = heightmap[(i+(j+1)*width) < 0 || i+(j+1)*width >= width*width ? (i+j*width) : (i+(j+1)*width)];
				
				vec3 normal = vec3(heightL-heightR, 2, heightD-heightU).normalized;
				
				vertices[i + j * width] = Vertex(vec3(x,cast(float)heightmap[i+j*width],y), vec2(texX,texY), normal);
			}
		}
		
		heightmap = hm;
		texturemap = tm;
		
		mesh.newVertices(vertices);
	}
	
	public static Terrain generateTerrain(uint width) {
		float hm[];
		vec4 tm[];
		hm.length = tm.length = width*width;
		
		Perlin perl = new Perlin();
		perl.SetSeed(cast(int)Clock.currSystemTick().msecs());
		
		for(uint i=0; i<width; i++) {
			for(uint j=0; j<width; j++) {
				uint index = i + width * j;
				hm[index] = 10 * cast(float)perl.GetValue(cast(double)i/100.0,0,cast(double)j/100.0);
				if(hm[index] <= -1.5) {
					tm[index] = vec4(0,1,0,0);
				} else {
					tm[index] = vec4(1,0,0,0);
				}
			}
		}
		
		return new Terrain(hm, width, tm);
	}
	
	private Mesh generateTerrain() {
		int count = width * width;
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
				float x = cast(float)i - width/2.0;
				float y = cast(float)j - width/2.0;
				
				float heightL = heightmap[i-1+j*width < 0 || i-1+j*width >= width*width ? (i+j*width) : (i-1+j*width)];
				float heightR = heightmap[i+1+j*width < 0 || i+1+j*width >= width*width ? (i+j*width) : (i+1+j*width)];
				float heightD = heightmap[(i+(j-1)*width) < 0 || i+(j-1)*width >= width*width ? (i+j*width) : (i+(j-1)*width)];
				float heightU = heightmap[(i+(j+1)*width) < 0 || i+(j+1)*width >= width*width ? (i+j*width) : (i+(j+1)*width)];
				
				vec3 normal = vec3(heightL-heightR, 2, heightD-heightU).normalized;
				
				vertices[i + j * width] = Vertex(vec3(x,cast(float)heightmap[i+j*width],y), vec2(texX,texY), normal);
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
		
		return new Mesh(vertices, indices, GL_DYNAMIC_DRAW);
	}
}