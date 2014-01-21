package br.com.ajwebdesign.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class Rasterizer{
		
		public function Rasterizer() {
			
		}
		
		public static function rasterize(target:DisplayObjectContainer):void {
			var i:int = 0;
			var j:int = target.numChildren;
			var bd:BitmapData = new BitmapData(target.width, target.height);
			
			for (i = 0; i < j; i++) {
				var content:DisplayObject = target.getChildAt(i);
				//bd.draw( content, new Matrix(content.scaleX, 0, 0, content.scaleY, content.x, content.y  ));
				bd.draw( content, new Matrix(content.scaleX, 0, 0, content.scaleY, content.x, content.y  ));
			}
			for (i = 0; i < j; i++) {
				//target.removeChildAt(0);
			}
			var bitmap:Bitmap = new Bitmap(bd);
			target.addChild(bitmap);
		}
		
	}

}