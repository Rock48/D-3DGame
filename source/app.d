import std.stdio;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.opengl3.gl3;
import display;
import mesh;
import shader;
import texture;
import gl3n.linalg;

Display window;
Mesh mesh1;
Shader basicShader;
Texture bricks;

void main() {
	DerelictSDL2.load();
	DerelictGL3.load();
	DerelictSDL2Image.load();

	writeln("SDL2 and OpenGL loaded successfully!");
	
	window = new Display(1280, 720, "Hello, World!");
	
	writeln("SDL initialized successfully!");
	
	DerelictGL3.reload();
	load();
	
	while(!window.wasClosed) {
		window.updateWindow();
		update();
		render();
	}
}

void load() {
	glClearColor(0.0f, 0.15f, 0.3f, 1.0f);
	Vertex vertices[] = [ Vertex(vec3(0,0.5,0), vec2(0.5,1)),
	 					  Vertex(vec3(0.5,-0.5,0), vec2(0,0)),
	 					  Vertex(vec3(-0.5,-0.5,0), vec2(1,0)) ];
	 					  
	mesh1 = new Mesh(vertices);

	basicShader = new Shader("shaders/basic");
	bricks = new Texture("textures/bricks.png");
	
}

void update() {
	
}

void render() {
	bricks.bind(0);
	basicShader.bind();
	glClear(GL_COLOR_BUFFER_BIT);
	mesh1.draw();
}
