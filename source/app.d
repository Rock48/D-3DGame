import std.stdio;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.opengl3.gl3;
import display;
import mesh;
import shader;
import texture;
import gl3n.linalg;
import transform;
import camera;
import terrain;

Display window;
Mesh mesh1;
Mesh ground;
Shader basicShader;
Texture bricks;
Camera cam1;

int WIDTH = 1280;
int HEIGHT = 720;

bool forward, backward, left, right;

Transform transf;
Transform groundTrans;
Transform transf2;

Texture bricks2;

Texture grass;
Texture water;

Terrain terr;
Terrain wtr;

void main() {
	DerelictSDL2.load();
	DerelictGL3.load();
	DerelictSDL2Image.load();

	writeln("SDL2 and OpenGL loaded successfully!");
	
	window = new Display(WIDTH, HEIGHT, "Hello, World!");
	
	writeln("SDL initialized successfully!");
	
	glEnable(GL_DEPTH_TEST);
	
	DerelictGL3.reload();
	load();
	
	while(!window.wasClosed) {
		window.updateWindow();
		update();
		render();
	}
}
float i = 0;
void load() {
	glClearColor(0.0f, 0.15f, 0.3f, 1.0f);
//	Vertex vertices[] = [ Vertex(vec3(0,0.5,0), vec2(0.5,1)),
//	 					  Vertex(vec3(-0.5,-0.5,-0.5), vec2(0,0)),
//	 					  Vertex(vec3(0.5,-0.5,-0.5), vec2(1,0)),
//	 					  Vertex(vec3(0,-0.5,0.5), vec2(0,0)), ];
//	uint indices[] = [ 0, 1, 2,
//					   0, 1, 3,
//					   0, 2, 3,
//					   1, 2, 3];
//	mesh1 = new Mesh(vertices, indices);
//	
	Vertex planeVertices[] = [ Vertex(vec3(-10,0,-10), vec2(0,0)),
	 						 Vertex(vec3(-10,0,10), vec2(0,1)),
	 						 Vertex(vec3(10,0,10), vec2(1,1)),
	 						 Vertex(vec3(10,0,-10), vec2(1,0))];
	uint planeIndices[] = [ 0,1,3, 1, 3, 2 ];
	ground = new Mesh(planeVertices, planeIndices);
	
	basicShader = new Shader("shaders/basic");
//	bricks = new Texture("textures/bricks.png");
//	bricks2 = new Texture("textures/bricks2.png");
//	
	transf = new Transform();
//	groundTrans = new Transform();
//	transf2 = new Transform();
//	
//	transf2.pos = vec3(6,0,-6);
//	transf2.scale = vec3(2,2,2);
	
//	groundTrans.pos.y = -2;
	
	grass = new Texture("textures/grass.png");
	
	cam1 = new Camera(vec3(0,1,-3), 70.0f, WIDTH, HEIGHT, 0.01, 1000);
	
	float heightmap[255*255];

	for(uint i=0; i<255; i++) {
		for(uint j=0; j<255; j++) {
			heightmap[i + 255*j] = -2;
		}
	}
	
	wtr = new Terrain(heightmap, 255);
	terr = Terrain.generateTerrain(255);//new Terrain(heightmap, 7);
	
	water = new Texture("textures/water.png");
	
	SDL_ShowCursor(SDL_DISABLE);
	SDL_SetWindowGrab(window.window, SDL_TRUE);
	SDL_SetRelativeMouseMode(true);
}

void update() {
//	i+=0.01;
//	transf.rot.y = i;
//	transf2.rot.y = -i;
	
	if(forward) {
		cam1.moveForward(0.03);
	}
	if(backward) {
		cam1.moveForward(-0.03);
	}
	if(left) {
		cam1.moveLeft(0.03);
	}
	if(right) {
		cam1.moveLeft(-0.03);
	}
}

void render() {
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	basicShader.bind();
	basicShader.update(transf,cam1);
	grass.bind(0);
	terr.mesh.draw();
	water.bind(0);
	wtr.mesh.draw();
//	
//	basicShader.update(transf, cam1);
//	bricks.bind(0);
//	mesh1.draw();
//	
//	basicShader.update(transf2, cam1);
//	mesh1.draw();
//	
//	
//	basicShader.update(groundTrans, cam1);
//	bricks2.bind(0);
//	ground.draw();
}

void keyDown(SDL_Keycode key) {
	if(key == SDL_GetKeyFromName("w")) {
		forward = true;
	}
	if(key == SDL_GetKeyFromName("s")) {
		backward = true;
	}
	if(key == SDL_GetKeyFromName("a")) {
		left = true;
	}
	if(key == SDL_GetKeyFromName("d")) {
		right = true;
	}
}

bool wireframe;

void keyUp(SDL_Keycode key) {
	if(key == SDL_GetKeyFromName("w")) {
		forward = false;
	}
	if(key == SDL_GetKeyFromName("s")) {
		backward = false;
	}
	if(key == SDL_GetKeyFromName("a")) {
		left = false;
	}
	if(key == SDL_GetKeyFromName("d")) {
		right = false;
	}
	
	if(key == SDL_GetKeyFromName("f1")) {
		wireframe = !wireframe;
		if(wireframe) {
			glPolygonMode( GL_FRONT_AND_BACK, GL_LINE );
		} else {
			glPolygonMode( GL_FRONT_AND_BACK, GL_FILL );
		}
	}
}

void mouseMoved(int x, int y) {
	cam1.rotateY(x/400.0);
	cam1.pitch(-y/400.0);
	
	//SDL_SetCursor(WIDTH/2, HEIGHT/2);
}
