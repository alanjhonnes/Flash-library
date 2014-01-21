package br.com.ajwebdesign.drawing.cursors {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.ui.MouseCursorData;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class DragHand extends MouseCursorData  {
		
		public static const NAME:String = "DragHand";
		
		private var hand:Shape;
		
		
		public function DragHand() {
			
		}
		
		public static function register():void {
			Mouse.registerCursor(NAME, new DragHand());
		}
		
	}

}