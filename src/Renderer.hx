package;

import js.Browser;
import js.html.BodyElement;
import js.html.Document;
import js.html.CanvasElement;
import js.html.Float32Array;
import js.html.svg.URIReference;
import js.html.Uint16Array;
import js.html.webgl.Buffer;
import js.html.webgl.GL;
import js.html.webgl.Program;
import js.html.webgl.RenderingContext;
import js.html.webgl.Shader;
import js.html.webgl.UniformLocation;
import js.Lib;

class Renderer {
	
	static var WIDTH:Int = 1280;
	static var HEIGHT:Int = 768;
	
	private var _context:RenderingContext;
	
	public function new() {
		var document:Document = Browser.document;
		var body:BodyElement = cast document.body;
		var canvasElement:CanvasElement = document.createCanvasElement();
		canvasElement.width = WIDTH;
		canvasElement.height = HEIGHT;
		body.appendChild( canvasElement );
		
		this._context = canvasElement.getContextWebGL();
		this._context.clearColor( 0.9, 0.9, 0.9, 1.0 );
		this._context.clear( GL.COLOR_BUFFER_BIT );
		
		var vertexShaderCode:String =
			'attribute vec2 position;' +
			'uniform mat3 ppMatrix;' +
			'uniform mat3 mvMatrix;' +
			//'varying vec3 outputColor;' +
			'void main() {' +
			'	vec3 pos = ppMatrix * mvMatrix * vec3( position.x, position.y, 1.0 );' +
			//'	outputColor = vec3( 1.0, 0.0, 0.0 );' +
			'	gl_Position = vec4( pos.x, pos.y, 0.0, 1.0 );' +
			'}';
		
		var fragmentShaderCode:String =
			'precision mediump float;' +
			'void main() {' +
			'	gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );' +
			'}';
		
		var program:Program = this.createProgram( vertexShaderCode, fragmentShaderCode );
		this._context.useProgram( program );
		
		var mvMatrix:Matrix = new Matrix();
		mvMatrix.setTRS( 200.0, 200.0, 45.0 * Math.PI / 180.0, 1.0, 1.0 );
		
		var ppMatrix:Matrix = new Matrix();
		ppMatrix.a = 2.0 / WIDTH;
		ppMatrix.d = -2.0 / HEIGHT;
		ppMatrix.tx = -1.0;
		ppMatrix.ty = 1.0;
		//a c e(tx)
		//b d f(ty)
		
		var mvMatrixLocation:UniformLocation = this._context.getUniformLocation( program, "mvMatrix" );
		this._context.uniformMatrix3fv( mvMatrixLocation, false, new Float32Array([
			mvMatrix.a, mvMatrix.b, 0.0,
			mvMatrix.c, mvMatrix.d, 0.0,
			mvMatrix.tx, mvMatrix.ty, 1.0
		]));
		
		var ppMatrixLocation:UniformLocation = this._context.getUniformLocation( program, "ppMatrix" );
		this._context.uniformMatrix3fv( ppMatrixLocation, false, new Float32Array([
			ppMatrix.a, ppMatrix.b, 0.0,
			ppMatrix.c, ppMatrix.d, 0.0,
			ppMatrix.tx, ppMatrix.ty, 1.0
		]));
		
		//
		
		var vertexBuffer:Buffer = this._context.createBuffer();
		this._context.bindBuffer( GL.ARRAY_BUFFER, vertexBuffer );
		var verteces:Float32Array = new Float32Array([
			0.0, 0.0,
			100.0, 0.0,
			0.0, 100.0,
			100.0, 100.0
		]);
		this._context.bufferData( GL.ARRAY_BUFFER, verteces, GL.STATIC_DRAW );
		var vertexAttributeLocation:Int = this._context.getAttribLocation( program, "position" );
		this._context.enableVertexAttribArray( vertexAttributeLocation );
		this._context.vertexAttribPointer( vertexAttributeLocation, 2, GL.FLOAT, false, 0, 0 );
		
		//
		
		var indexBuffer:Buffer = this._context.createBuffer();
		this._context.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, indexBuffer );
		var indices:Uint16Array = new Uint16Array([
			1, 0, 2,
			1, 2, 3
		]);
		this._context.bufferData( GL.ELEMENT_ARRAY_BUFFER, indices, GL.STATIC_DRAW );
		
		//
		
		this._context.drawElements( GL.TRIANGLES, 6, GL.UNSIGNED_SHORT, 0 );
		
		
		
	}
	
	private function createProgram( vertexShaderCode:String, fragmentShaderCode:String ):Program {
		var program:Program = this._context.createProgram();
		var vertexShader:Shader = this.createShader( vertexShaderCode, GL.VERTEX_SHADER );
		var fragmentShader:Shader = this.createShader( fragmentShaderCode, GL.FRAGMENT_SHADER );
		this._context.attachShader( program, vertexShader );
		this._context.attachShader( program, fragmentShader );
		this._context.linkProgram( program );
		return program;
	}
	
	private function createShader( code:String, type:Int ):Shader {
		var shader:Shader = this._context.createShader( type );
		this._context.shaderSource( shader, code );
		this._context.compileShader( shader );
		return shader;
	}
	
}