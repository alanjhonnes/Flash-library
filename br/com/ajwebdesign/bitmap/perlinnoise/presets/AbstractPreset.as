package br.com.ajwebdesign.bitmap.perlinnoise.presets {
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class AbstractPreset {
		
		public var backgroundColor:uint;
		public var octaves:uint;
		public var speeds:Vector.<Point>;
		public var offsets:Array;
		public var baseX:Number;
		public var baseY:Number;
		public var seed:int;
		public var stitch:Boolean;
		public var fractal:Boolean;
		public var channels:uint;
		public var grayScale:Boolean;
		public var animated:Boolean;
		public var blendMode:String = BlendMode.NORMAL;
		public var alpha:Number = 1;
		public var filters:Array = [];
		public var isGradient:Boolean;
		public var gradientType:String = GradientType.LINEAR;
		public var colors:Array;
		public var alphas:Array;
		public var ratios:Array;
		public var matrix:Matrix;
		public var angle:Number = 0;
		public var spreadMethod:String = SpreadMethod.PAD;
		public var interpolationMethod:String = InterpolationMethod.RGB;
		public var focalPointRatio:Number = 0;
		
		public function AbstractPreset() {
			
		}
		
	}

}