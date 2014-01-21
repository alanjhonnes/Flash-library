package br.com.ajwebdesign.bitmap.perlinnoise {
	import br.com.ajwebdesign.bitmap.perlinnoise.presets.AbstractPreset;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import temple.core.CoreSprite;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class PerlinTexture extends BitmapData {
		
		private var _width:int;
		private var _height:int;
		
		private var _backgroundColor:uint;
		private var _octaves:uint;
		private var _speeds:Vector.<Point>;
		private var _offsets:Array;
		private var _baseX:Number;
		private var _baseY:Number;
		private var _seed:int;
		private var _stitch:Boolean;
		private var _fractal:Boolean;
		private var _channels:uint;
		private var _grayScale:Boolean;
		private var _blendingMode:String;
		private var _alpha:Number;
		private var _filters:Array;
		private var _isGradient:Boolean;
		private var _gradientType:String;
		private var _colors:Array;
		private var _alphas:Array;
		private var _ratios:Array;
		private var _matrix:Matrix;
		private var _interpolationMethod:String;
		private var _spreadMethod:String;
		private var _angle:Number;
		private var _focalPointRatio:Number;
		private var _animated:Boolean;
		
		public var _locked:Boolean;
		
		public function PerlinTexture(width:int, height:int, preset:AbstractPreset = null) {
			_width = width;
			_height = height;
			super(_width, _height, true, 0x00FFFFFF);
			if (preset) {
				loadPreset(preset);
			}
			
		}
		
		override public function lock():void {
			_locked = true;
			animated = false;
			super.lock();
		}
		
		override public function unlock(changeRect:Rectangle = null):void {
			_locked = false;
			animated = true;
			super.unlock(changeRect);
		}
		
		public function redraw():void {
			var i:int = 0;
			var j:int = _offsets.length;
			for (i; i < j; i++) {
				var offset:Point = offsets[i] as Point;
				offset.x += speeds[i].x;
				offset.y += speeds[i].y;
			}
			perlinNoise(_baseX, _baseY, octaves, _seed, _stitch, _fractal, _channels, _grayScale, _offsets);
			j = _filters.length;
			for (i = 0; i < j; i++) {
				var filter:BitmapFilter = filters[i] as BitmapFilter;
				applyFilter(this, new Rectangle(0, 0, _width, _height), new Point(0, 0), filter);
			}
		}
		
		public function loadPreset(preset:AbstractPreset):void {
			_backgroundColor = preset.backgroundColor;
			_octaves = preset.octaves;
			_speeds = preset.speeds;
			_offsets = preset.offsets;
			_baseX = preset.baseX;
			_baseY = preset.baseY;
			_seed = preset.seed;
			_stitch = preset.stitch;
			_fractal = preset.fractal;
			_channels = preset.channels;
			_grayScale = preset.grayScale;
			_blendingMode = preset.blendMode;
			_alpha = preset.alpha;
			_animated = preset.animated;
			_filters = preset.filters;
			_isGradient = preset.isGradient;
			_gradientType = preset.gradientType;
			_colors = preset.colors;
			_alphas = preset.alphas;
			_ratios = preset.ratios;
			_matrix = preset.matrix;
			_angle = preset.angle;
			_interpolationMethod = preset.interpolationMethod;
			_spreadMethod = preset.spreadMethod;
			_focalPointRatio = preset.focalPointRatio;
			redraw();
		}
		
		public function invalidate():void {
			if (!_animated && _locked) {
				redraw();
			}
		}
		
		private function onEnterFrame(e:Event):void {
			redraw();
		}
		
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			invalidate();
			
		}
		
		public function get octaves():uint {
			return _octaves;
		}
		
		public function set octaves(value:uint):void {
			_octaves = value;
			invalidate();
		}
		
		public function get speeds():Vector.<Point> {
			return _speeds;
		}
		
		public function set speeds(value:Vector.<Point>):void {
			_speeds = value;
			invalidate();
		}
		
		public function get offsets():Array {
			return _offsets;
		}
		
		public function set offsets(value:Array):void {
			_offsets = value;
			invalidate();
		}
		
		public function get baseX():Number {
			return _baseX;
		}
		
		public function set baseX(value:Number):void {
			_baseX = value;
			invalidate();
		}
		
		public function get baseY():Number {
			return _baseY;
		}
		
		public function set baseY(value:Number):void {
			_baseY = value;
			invalidate();
		}
		
		public function get seed():int {
			return _seed;
		}
		
		public function set seed(value:int):void {
			_seed = value;
			invalidate();
		}
		
		public function get stitch():Boolean {
			return _stitch;
		}
		
		public function set stitch(value:Boolean):void {
			_stitch = value;
			invalidate();
		}
		
		public function get fractal():Boolean {
			return _fractal;
		}
		
		public function set fractal(value:Boolean):void {
			_fractal = value;
			invalidate();
		}
		
		public function get channels():uint {
			return _channels;
		}
		
		public function set channels(value:uint):void {
			_channels = value;
			invalidate();
		}
		
		
		public function get grayScale():Boolean {
			return _grayScale;
		}
		
		public function set grayScale(value:Boolean):void {
			_grayScale = value;
			invalidate();
		}
		
		public function get blendingMode():String {
			return _blendingMode;
		}
		
		public function set blendingMode(value:String):void {
			_blendingMode = value;
		}
		
		public function get animated():Boolean {
			return _animated;
		}
		
		public function set animated(value:Boolean):void {
			_animated = value;
			/*
			if (_animated) {
				if (!hasEventListener(Event.ENTER_FRAME)) {
					addEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
			else {
				if (hasEventListener(Event.ENTER_FRAME)) {
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
			*/
		}
		
		public function get alpha():Number {
			return _alpha;
		}
		
		public function set alpha(value:Number):void {
			_alpha = value;
		}
		
		public function get filters():Array {
			return _filters;
		}
		
		public function set filters(value:Array):void {
			_filters = value;
			invalidate();
		}
		
		public function get isGradient():Boolean {
			return _isGradient;
		}
		
		public function set isGradient(value:Boolean):void {
			_isGradient = value;
		}
		
		public function get colors():Array {
			return _colors;
		}
		
		public function set colors(value:Array):void {
			_colors = value;
		}
		
		public function get ratios():Array {
			return _ratios;
		}
		
		public function set ratios(value:Array):void {
			_ratios = value;
		}
		
		public function get matrix():Matrix {
			return _matrix;
		}
		
		public function set matrix(value:Matrix):void {
			_matrix = value;
		}
		
		public function get angle():Number {
			return _angle;
		}
		
		public function set angle(value:Number):void {
			_angle = value;
		}
		
		public function get alphas():Array {
			return _alphas;
		}
		
		public function set alphas(value:Array):void {
			_alphas = value;
		}
		
		public function get interpolationMethod():String {
			return _interpolationMethod;
		}
		
		public function set interpolationMethod(value:String):void {
			_interpolationMethod = value;
		}
		
		public function get spreadMethod():String {
			return _spreadMethod;
		}
		
		public function set spreadMethod(value:String):void {
			_spreadMethod = value;
		}
		
		public function get gradientType():String {
			return _gradientType;
		}
		
		public function set gradientType(value:String):void {
			_gradientType = value;
		}
		
		public function get focalPointRatio():Number {
			return _focalPointRatio;
		}
		
		public function set focalPointRatio(value:Number):void {
			_focalPointRatio = value;
		}
		
	}

}