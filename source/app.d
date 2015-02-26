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
import std.datetime;

Display window;
Mesh mesh1;
Mesh ground;
Shader basicShader;
Texture bricks;
Camera cam1;

int WIDTH = 1440;
int HEIGHT = 900;

bool forward, backward, left, right;

Transform transf;
Transform groundTrans;
Transform transf2;

Texture bricks2;

Texture grass;
Texture water;

Texture sand;

Terrain terr;
Terrain wtr;

Shader terrainShader;

void main() {
	DerelictSDL2.load();
	DerelictGL3.load();
	DerelictSDL2Image.load();

	writeln("SDL2 and OpenGL loaded successfully!");
	
	window = new Display(WIDTH, HEIGHT, "Hello, World!");
	
	writeln("SDL initialized successfully!");
	
	glEnable(GL_DEPTH_TEST);
	writeln("enabled depth testing");
	
	DerelictGL3.reload();
	writeln("finished initializing opengl");
	load();
	
	long curtime = 0;
	long oldtime = 0;
	float dt;
	
	glEnable(GL_CULL_FACE);
	
	while(!window.wasClosed) {
		curtime = Clock.currSystemTick().msecs();
		dt = (curtime-oldtime)/1000.0f;
		oldtime = curtime;
		window.updateWindow();
		update(dt);
		render();
	}
}
float i = 0;
void load() {
	glEnable (GL_BLEND);
	glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glClearColor(.5f, 0.7f, 1f, 0f);
	
	writeln("clear color set");
	
	Vertex planeVertices[] = [ Vertex(vec3(-255/2.0,0,-255/2.0), vec2(0,0), vec3(0,1,0)),
	 						 Vertex(vec3(-255/2.0,0,255/2.0), vec2(0,100), vec3(0,1,0)),
	 						 Vertex(vec3(255/2.0,0,255/2.0), vec2(100,100), vec3(0,1,0)),
	 						 Vertex(vec3(255/2.0,0,-255/2.0), vec2(100,0), vec3(0,1,0))];
	uint planeIndices[] = [ 0,1,3, 1, 3, 2 ];
	ground = new Mesh(planeVertices, planeIndices, GL_STATIC_DRAW);
	
	
	
	basicShader = new Shader("shaders/basic");
	writeln("initialized basic shader");
	terrainShader = new TerrainShader("shaders/terrain");
	writeln("initialized terrain shader");
	
	bricks = new Texture("textures/bricks.png");
	
	transf = new Transform();
	groundTrans = new Transform();
	
	groundTrans.pos.y = -3;
	
	grass = new Texture("textures/grass.png");
	sand = new Texture("textures/sand.png");
	writeln("initialized textures");
	
	cam1 = new Camera(vec3(0,1,-3), 70.0f, WIDTH, HEIGHT, 0.01, 1000);
	writeln("initialized camera");
	
	terr = Terrain.generateTerrain(256);//new Terrain(heightmap, 7);
	wtr = Terrain.generateTerrain(32);
	groundTrans.scale = vec3(8,1,8);
	writeln("initialized grass terrain");
	
	water = new Texture("textures/water.png");
	writeln("initialized water texture");
	
	SDL_ShowCursor(SDL_DISABLE);
	SDL_SetWindowGrab(window.window, SDL_TRUE);
	SDL_SetRelativeMouseMode(true);
}


void update(float dt) {
	i+=dt;
	wtr.regenerate(i, 1);
//	transf.rot.y = i;
//	transf2.rot.y = -i;
	//groundTrans.pos.y = sin(i)/3-2;
	
	if(forward) {
		cam1.moveForward(0.05);
	}
	if(backward) {
		cam1.moveForward(-0.05);
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
	terrainShader.bind();
	terrainShader.update(transf,cam1,vec4(1,1,1,1));
	grass.bind(0);
	sand.bind(1);
	terr.mesh.draw();
	basicShader.bind();
	basicShader.update(groundTrans,cam1,vec4(0.35,0.7,0.6,0.7));
	water.bind(0);
	water.bind(1);
	wtr.mesh.draw();
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
	if(key == SDL_GetKeyFromName("escape")){
		window.wasClosed = true;
	}
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
}
