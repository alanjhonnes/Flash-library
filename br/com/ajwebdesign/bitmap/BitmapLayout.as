package br.com.ajwebdesign.bitmap {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import temple.core.CoreObject;
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class BitmapLayout extends CoreObject{
		
		private var _bitmapData:BitmapData;
		private var _width:Number;
		private var _height:Number;
		private var _x:Number;
		private var _y:Number;
		
		public function BitmapLayout(target:DisplayObject) {
			_width = target.width;
			_height = target.height;
			_x = target.x;
			_y = target.y;
			_bitmapData = new BitmapData(_width, _height, true, 0x00000000);
			_bitmapData.draw(target);
		}
		
		public function getNextPoint():Point {
			var found:Boolean = false;
			var x:int;
			var y:int;
			while (!found) {
				x = Math.random() * _width;
				y = Math.random() * _height;
				var color:uint = _bitmapData.getPixel32(x, y);
				if (color != 0x00000000) {
					found = true;
				}
			}
			var pt:Point = new Point(x + _x, y + _y);
			return pt;
		}
		
		override public function destruct():void {
			_bitmapData.dispose();
			_bitmapData = null;
			super.destruct();
		}
		
	}

}