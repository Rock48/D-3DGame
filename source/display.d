import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.opengl3.gl3;
import std.string;
import std.stdio;
import app;

int mouseX = 0;
int mouseY = 0;

class Display {
	SDL_Window* window;
	SDL_GLContext context;
	bool wasClosed;
	
	this(int width, int height, string title) {
		SDL_Init(SDL_INIT_EVERYTHING);
	
		SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
		SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
		SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
		SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 8);
		SDL_GL_SetAttribute(SDL_GL_BUFFER_SIZE, 32);
	
		// Config setting is probably a good idea here
		SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
		
		int imgstatus = IMG_Init(IMG_INIT_PNG);
		
		if((imgstatus&IMG_INIT_PNG) != IMG_INIT_PNG) {
			stderr.writeln("IMG_Init: failed to initialize PNG support!");
			stderr.writefln("IMG_Init: %s", IMG_GetError());
		} else {
			writeln("Images initialized successfully!");
		}
		
		window = SDL_CreateWindow(toStringz(title), SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height, SDL_WINDOW_OPENGL);
		context = SDL_GL_CreateContext(window);
		
		wasClosed = false;
	}
	
	~this() {
		// Shut down stuff
		SDL_GL_DeleteContext(context);
		SDL_DestroyWindow(window);
		SDL_Quit();
		IMG_Quit();
	}
	
	void updateWindow() {
		SDL_GL_SwapWindow(window);
	
		SDL_Event e;
	
		while(SDL_PollEvent(&e)) {
			if(e.type == SDL_QUIT) {
				wasClosed = true;
			}
			if(e.type == SDL_KEYDOWN) {
				keyDown(e.key.keysym.sym);
			}
			if(e.type == SDL_KEYUP) {
				keyUp(e.key.keysym.sym);
			}
			if(e.type == SDL_MOUSEMOTION) {
				auto relx = e.motion.xrel;
				auto rely = e.motion.yrel;
				
				mouseX = e.motion.x;
				mouseY = e.motion.y;
				
				mouseMoved(relx, rely);
			}
		}
	}
}