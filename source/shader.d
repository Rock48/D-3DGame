import std.file;
import std.stdio;
import std.string;
import transform;
import derelict.opengl3.gl3;
import gl3n.linalg;
import camera;

class Shader {
	private uint program;
	
	private uint vertexShader;
	private uint fragmentShader;
	
	private int transformUniform;
	private int worldUniform;
	private int colorUniform;
	
	static int NULL = 0;
	
	this(string filename) {
		program = glCreateProgram();
		
		vertexShader = createShader(filename ~ ".vsh", GL_VERTEX_SHADER);
		fragmentShader = createShader(filename ~ ".fsh", GL_FRAGMENT_SHADER);
		writeln("shaders created and compiled");
		
		glAttachShader(program, vertexShader);
		glAttachShader(program, fragmentShader);
		writeln("shaders attached");
		
		bindAttributes();
		writeln("attributes bound");
		
		glLinkProgram(program);
		checkForShaderError(program, GL_LINK_STATUS, true, "Error; Program linking failed!"); 
		writeln("shader linked");
		
		glValidateProgram(program);
		checkForShaderError(program, GL_VALIDATE_STATUS, true, "Error; Program validation failed!");
		writeln("shader validated");
		
		transformUniform = glGetUniformLocation(program, "transform");
		writeln("transform uniform gotten");
		worldUniform = glGetUniformLocation(program, "world");
		writeln("world uniform gotten");
		colorUniform = glGetUniformLocation(program, "color");
		writeln("color shader gotten");
	}
	
	void update(Transform transform, Camera camera, vec4 color) {
		mat4 model = transform.getModel();
		glUniformMatrix4fv(transformUniform, 1, GL_TRUE, model.value_ptr);
		mat4 world = camera.getViewProjection();
		glUniformMatrix4fv(worldUniform, 1, GL_TRUE, world.value_ptr);
		glUniform4fv(colorUniform, 1, color.value_ptr);
	}
	
	void bindAttributes() {
		glBindAttribLocation(program, 0, "position");
		glBindAttribLocation(program, 1, "texCoord");
		glBindAttribLocation(program, 2, "normal");
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

class TerrainShader : Shader {
	
	uint tex1;
	uint tex2;
	uint tex3;
	uint tex4;
	
	this(string filename) {
		super(filename);
		tex1 = glGetUniformLocation(program, "tex1");
		tex2 = glGetUniformLocation(program, "tex2");
		tex3 = glGetUniformLocation(program, "tex3");
		tex4 = glGetUniformLocation(program, "tex4");
		writeln("texture uniforms grabbed");
	}
	
	override void update(Transform transform, Camera camera, vec4 color) {
		super.update(transform, camera, color);
		glUniform1i(tex1, 0);
		glUniform1i(tex2, 1);
		glUniform1i(tex3, 2);
		glUniform1i(tex4, 3);
	}
	
	override void bindAttributes() {
		super.bindAttributes();
		glBindAttribLocation(program, 3, "texValue");
	}
}