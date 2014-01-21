package br.com.ajwebdesign.bitmap.perlinnoise {
	import br.com.ajwebdesign.bitmap.perlinnoise.PerlinTexture;
	import br.com.ajwebdesign.bitmap.perlinnoise.presets.AbstractPreset;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import temple.core.CoreSprite;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class SpriteTexture extends CoreSprite {
		
		private var shape:Shape = new Shape();
		private var _texture:PerlinTexture;
		private var _bitmap:Bitmap;
		private var _textureWidth:Number;
		private var _textureHeight:Number;
		private var _alignment:String;
		private var _backgroundColor:uint;
		
		private var _halfWidth:Number;
		private var _halfHeight:Number;
		
		private var isGradient:Boolean;
		private var gradientType:String;
		private var colors:Array;
		private var alphas:Array;
		private var ratios:Array;
		private var matrix:Matrix;
		private var angle:Number;
		private var interpolationMethod:String;
		private var spreadMethod:String;
		private var focalPointRatio:Number;
		private var _alpha:Number;
		
		private var background:Graphics;
		
		public static const TOP_LEFT:String = "topLeft";
		public static const BOTTOM:String = "bottom";
		
		override public function destruct():void {
			_texture = null
			_bitmap = null;
			super.destruct();
		}
		
		public function SpriteTexture(perlinTexture:PerlinTexture, width:Number = 100, height:Number = 25, alignment:String = "topLeft", pixelSnapping:String = "auto", smoothing:Boolean = false) {
			_texture = perlinTexture;
			_alignment = alignment;
			_bitmap = new Bitmap(_texture, pixelSnapping, smoothing);
			_bitmap.blendMode = perlinTexture.blendingMode;
			_bitmap.alpha = _texture.alpha;
			addChild(shape);
			addChild(_bitmap);
			_textureWidth = width;
			_textureHeight = height;
			_halfWidth = Math.ceil(_textureWidth * 0.5);
			_halfHeight = Math.ceil(_textureHeight * 0.5);
			_backgroundColor = _texture.backgroundColor;
			_alpha = _texture.alpha;
			background = shape.graphics;
			isGradient = _texture.isGradient;
			if (isGradient) {
				gradientType = _texture.gradientType;
				colors = _texture.colors;
				alphas = _texture.alphas;
				ratios = _texture.ratios;
				matrix = _texture.matrix;
				angle = _texture.angle;
				interpolationMethod = _texture.interpolationMethod;
				spreadMethod = _texture.spreadMethod;
				focalPointRatio = _texture.focalPointRatio;
			}
			redraw();
		}
		
		public function redraw():void {
			drawShape();
			switch(_alignment) {
				case TOP_LEFT: {
					shape.x = 0;
					shape.y = 0;
					_bitmap.x = 0;
					_bitmap.y = 0;
					_bitmap.width = _textureWidth;
					_bitmap.height = _textureHeight;
					break;
				}
				case BOTTOM: {
					
					break;
				}
			}
			graphics.endFill();
		}
		
		protected function drawShape():void {
			background.clear();
			if (isGradient) {
				matrix.createGradientBox(_textureWidth, _textureHeight, angle);
				background.beginGradientFill(gradientType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			}
			else {
				background.beginFill(_backgroundColor, _alpha);
			}
			background.drawRect(0, 0, _textureWidth, _textureHeight);
		}
		
		public function setSize(width:Number, height:Number):void {
			_textureWidth = width;
			_textureHeight = height;
			redraw();
		}
		
		public function get texture():PerlinTexture {
			return _texture;
		}
		
		public function set texture(value:PerlinTexture):void {
			_texture = value;
			_bitmap.bitmapData = _texture;
		}
		
		
		public function get bitmap():Bitmap {
			return _bitmap;
		}
		
		public function get textureWidth():Number {
			return _textureWidth;
		}
		
		public function set textureWidth(value:Number):void {
			_textureWidth = value;
			_halfWidth = Math.ceil(_textureWidth * 0.5);
			redraw();
		}
		
		public function get textureHeight():Number {
			return _textureHeight;
		}
		
		public function set textureHeight(value:Number):void {
			_textureHeight = value;
			_halfHeight = Math.ceil(_textureHeight * 0.5);
			redraw();
		}
		
		public function get alignment():String {
			return _alignment;
		}
		
		public function set alignment(value:String):void {
			_alignment = value;
			redraw();
		}
		
	}

}