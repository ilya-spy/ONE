package;

class Matrix {
	
	//a c tx
	//b d ty
	
	public var a( get_a, set_a ):Float;
	public var c( get_c, set_c ):Float;
	public var tx( get_tx, set_tx ):Float;
	public var b( get_b, set_b ):Float;
	public var d( get_d, set_d ):Float;
	public var ty( get_ty, set_ty ):Float;
	
	private var _a:Float = 1.0;
	private var _c:Float = 0.0;
	private var _tx:Float = 0.0;
	private var _b:Float = 0.0;
	private var _d:Float = 1.0;
	private var _ty:Float = 0.0;
	
	public function new() {
		
	}
	
	public function setTRS( tx:Float, ty:Float, rotation:Float, scaleX:Float, scaleY:Float ):Void {
		var sin:Float = Math.sin( rotation );
		var cos:Float = Math.cos( rotation );
		this._a =  cos * scaleX;
		this._c = -sin * scaleY;
		this._b =  sin * scaleX;
		this._d =  cos * scaleY;
		this._tx = tx;
		this._ty = ty;
	}
	
	public function get_a():Float { return this._a; }
	public function get_c():Float { return this._c; }
	public function get_tx():Float { return this._tx; }
	public function get_b():Float { return this._b; }
	public function get_d():Float { return this._d; }
	public function get_ty():Float { return this._ty; }
	
	public function set_a( value:Float ):Float { this._a = value; return this._a; }
	public function set_c( value:Float ):Float { this._c = value; return this._b; }
	public function set_tx( value:Float ):Float { this._tx = value; return this._tx; }
	public function set_b( value:Float ):Float { this._b = value; return this._b; }
	public function set_d( value:Float ):Float { this._d = value; return this._d; }
	public function set_ty( value:Float ):Float { this._ty = value; return this._ty; }
	
}