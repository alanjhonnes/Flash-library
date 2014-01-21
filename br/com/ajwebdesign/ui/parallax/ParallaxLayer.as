package br.com.ajwebdesign.ui.parallax {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class ParallaxLayer {
		
		public var depth:int;
		public var bitmapData:BitmapData;
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _offsetX:Number;
		private var _offsetY:Number;
		public var width:int;
		public var height:int;
		private var repeatX:Boolean;
		private var repeatY:Boolean;
		private var rect:Rectangle = new Rectangle();
		private var point:Point = new Point();
		private var destPoint:Point = new Point();
		private var _alignment:int;
		
		public function ParallaxLayer(bitmap:BitmapData, depth:int, repeatX:Boolean = true, repeatY:Boolean = false, alignment:int = 2, offsetX:Number = 0, offsetY:Number = 0 ) {
			bitmapData = bitmap;
			this.width = bitmap.width;
			this.height = bitmap.height;
			this.depth = depth;
			this.repeatX = repeatX;
			this.repeatY = repeatY;
			_offsetX = offsetX;
			_offsetY = offsetY;
			this._alignment = alignment;
		}
		
		public function copyScrolledBitmap(bitmap:BitmapData, totalWidth:int, totalHeight:int):void {
			var widthTiled:int;
			var remainningWidth:int = totalWidth;
			var i:int = 0;
			var j:int = 0;
			
			point.x = 0;
			point.y = _y;
			rect.height = height;
			rect.y = 0;
			if (x > 0) {
				rect.x = _x;
				widthTiled = width - _x;
				if (widthTiled > totalWidth) {
					widthTiled = totalWidth;
				}
				rect.width = widthTiled;
				rect.height = height;
				bitmap.copyPixels(bitmapData, rect, point, bitmapData, rect.topLeft, true);
				remainningWidth -= widthTiled;
				//tile the middle if needed
				if (remainningWidth > 0) {
					i= 0;
					j = (remainningWidth / width);
					//trace("j: "+ j);
					
					for (i; i < j; i++) {
						rect.x = 0;
						rect.width = width;
						rect.height = height;
						point.x = widthTiled;
						bitmap.copyPixels(bitmapData, rect, point, bitmapData, rect.topLeft, true);
						widthTiled += width;
						remainningWidth -= width;
					}
				}
				//tile with the left side to complete the loop
				if (remainningWidth > 0) {
					rect.x = 0;
					point.x = widthTiled;
					rect.width = remainningWidth;
					rect.height = height;
					bitmap.copyPixels(bitmapData, rect, point, bitmapData, rect.topLeft, true);
					widthTiled += rect.width;
				}
				
			}
			//Negative X
			else {
				rect.x = _x + width;
				//draw the right part of the image
				widthTiled = width - rect.x;
				if (widthTiled > totalWidth) {
					widthTiled = totalWidth;
				}
				rect.width = widthTiled;
				rect.height = height;
				bitmap.copyPixels(bitmapData, rect, point, bitmapData, rect.topLeft, true);
				remainningWidth -= widthTiled;
				//tile the middle
				
				i= 0;
				j = Math.floor(remainningWidth / width);
				for (i; i < j; i++) {
					rect.x = 0;
					rect.width = width;
					rect.height = height;
					point.x = widthTiled;
					bitmap.copyPixels(bitmapData, rect, point, bitmapData, rect.topLeft, true);
					widthTiled += width;
					remainningWidth -= width;
				}
				//tile with the left side to complete the loop
				if (remainningWidth > 0) {
					rect.x = 0;
					point.x = widthTiled;
					rect.width = remainningWidth;
					rect.height = height;
					bitmap.copyPixels(bitmapData, rect, point, bitmapData, rect.topLeft, true);
				}	
			}
		}
		
		public function get x():Number {
			return _x;
		}
		
		public function set x(value:Number):void {
			_x = value % width;
		}
		
		public function get y():int {
			return _y;
		}
		
		public function set y(value:int):void {
			_y = value;
		}
		
		public function get alignment():int {
			return _alignment;
		}
		
		public function set alignment(value:int):void {
			_alignment = value;
		}
		
		public function get offsetX():Number {
			return _offsetX;
		}
		
		public function set offsetX(value:Number):void {
			_offsetX = value;
		}
		
		public function get offsetY():Number {
			return _offsetY;
		}
		
		public function set offsetY(value:Number):void {
			_offsetY = value;
		}
		
	}

}