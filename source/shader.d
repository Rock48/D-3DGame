import std.file;
import std.stdio;
import std.string;
import derelict.opengl3.gl3;

class Shader {
	private uint program;
	
	private uint vertexShader;
	private uint fragmentShader;
	
	static int NULL = 0;
	
	this(string filename) {
		program = glCreateProgram();
		
		vertexShader = createShader(filename ~ ".vsh", GL_VERTEX_SHADER);
		fragmentShader = createShader(filename ~ ".fsh", GL_FRAGMENT_SHADER);
		
		glAttachShader(program, vertexShader);
		glAttachShader(program, fragmentShader);
		
		glBindAttribLocation(program, 0, "position");
		glBindAttribLocation(program, 1, "texCoord");
		
		glLinkProgram(program);
		checkForShaderError(program, GL_LINK_STATUS, true, "Error; Program linking failed!"); 
		
		glValidateProgram(program);
		checkForShaderError(program, GL_VALIDATE_STATUS, true, "Error; Program validation failed!"); 
	}
	
	void bind() {
		glUseProgram(program);
	}
	
	~this() {
		glDetachShader(program, vertexShader);
		glDeleteShader(vertexShader);
		
		glDetachShader(program, fragmentShader);
		glDeleteShader(fragmentShader);
		
		glDeleteProgram(program);
	}
	
	static uint createShader(string filename, GLenum shaderType) {
		string shader_src = readText(filename);
		
		uint shader = glCreateShader(shaderType);
		if(shader == 0) {
			stderr.writeln("Error: Shader creation failed");
		}
		
		const(char)* shaderSources[1];
		int shaderSourceLengths[1] = [shader_src.length];
		
		shaderSources[0] = toStringz(shader_src);
		
		glShaderSource(shader, 1, shaderSources.ptr, shaderSourceLengths.ptr);
		glCompileShader(shader);
		
		checkForShaderError(shader, GL_COMPILE_STATUS, false, "Error; Compile Failed for Shader: " ~ filename); 
		
		return shader;
	}
	
	static void checkForShaderError(uint shader, uint flag, bool isProgram, string errorMessage) {
		int success = 0;
		char error[1024];
		
		if(isProgram) {
			glGetProgramiv(shader, flag, &success);
		} else {
			glGetShaderiv(shader, flag, &success);
		}
		
		if(success == GL_FALSE) {
			if(isProgram) {
				glGetProgramInfoLog(shader, error.sizeof, &NULL, error.ptr);
			} else {
				glGetShaderInfoLog(shader, error.sizeof, &NULL, error.ptr);
			}
			stderr.writeln(errorMessage ~ ": " ~ error.idup ~ "'");
		}
	}
}