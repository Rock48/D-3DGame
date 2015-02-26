import std.stdio;
import derelict.sdl2.image;
import derelict.sdl2.sdl;
import derelict.opengl3.gl3;
import std.string;

class Texture {
	uint texture;
	
	//TODO: Add support for versions of OpenGL below 4.5
	this(string filename) {
		SDL_Surface* image = IMG_Load(toStringz(filename));
		
		if(image == null) {
			stderr.writeln("Texture loading failed for texture: " ~ filename);
		}
		
		ubyte* apple = cast(ubyte*)image.pixels;
		
		glGenTextures(1, &texture);
		
		glTextureParameteriEXT(texture, GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTextureParameteriEXT(texture, GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
		
		glTextureParameterfEXT(texture, GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTextureParameterfEXT(texture, GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		
		glTextureImage2DEXT(texture, GL_TEXTURE_2D, 0, GL_RGBA, image.w, image.h, 0, GL_RGB, GL_UNSIGNED_BYTE, apple);
	}
	
	void bind(uint unit) {
		assert(unit >= 0 && unit <= 31);
		
		glActiveTexture(GL_TEXTURE0 + unit);
		glBindTexture(GL_TEXTURE_2D, texture);
	}
	
	~this() {
		glDeleteTextures(1, &texture);
	}
}