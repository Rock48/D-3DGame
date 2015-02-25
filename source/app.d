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

Terrain terr;

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
//	Vertex planeVertices[] = [ Vertex(vec3(-10,0,-10), vec2(0,0)),
//	 						 Vertex(vec3(-10,0,10), vec2(0,1)),
//	 						 Vertex(vec3(10,0,10), vec2(1,1)),
//	 						 Vertex(vec3(10,0,-10), vec2(1,0))];
//	uint planeIndices[] = [ 0,1,3, 1, 3, 2 ];
//	ground = new Mesh(planeVertices, planeIndices);
	
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
	
	float heightmap[7*7] = [ .3,  0, .3, .6, .3,  0, .3,
							  0, .3,  0, .3,  0, .3, .6,
							 .3, .3, .3,  0, .6, .3, .3,
							 .6,  1, .6, .3, .6, .6, .6,
							 .3,  0, .3, .6, .3,  0, .3,
							  0, .3,  0, .3,  0, .3, .6,
							 .3, .3, .3,  0, .6, .3, .3];
	
	
	terr = new Terrain(heightmap, 7);
	
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
}

void mouseMoved(int x, int y) {
	cam1.rotateY(x/400.0);
	cam1.pitch(-y/400.0);
	
	//SDL_SetCursor(WIDTH/2, HEIGHT/2);
}
