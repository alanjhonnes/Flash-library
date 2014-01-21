package br.com.ajwebdesign.utils {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class MouseDisabler {
		
		public function MouseDisabler() {
			
		}
		
		/**
		 * Disable all mouse interactions of the object,including nested objects
		 * @param	t Target 
		 */
		public static function disableMouse( t:DisplayObject ):void {
			if (t is InteractiveObject) {
				InteractiveObject(t).mouseEnabled = false;
				if ( t is DisplayObjectContainer) {
					var c:DisplayObjectContainer = DisplayObjectContainer(t);
					c.mouseChildren = false;
					var j:int = c.numChildren;
					var i:int = 0;
					for (i; i < j; i++) {
						disableMouse(c.getChildAt(i));
					}
				}
			}
		}
		
		/**
		 * Enable all mouse interactions of the object,including nested objects
		 * @param	t Target 
		 */
		public static function enableMouse( t:DisplayObject ):void {
			if (t is InteractiveObject) {
				InteractiveObject(t).mouseEnabled = true;
				if ( t is DisplayObjectContainer) {
					var c:DisplayObjectContainer = DisplayObjectContainer(t);
					c.mouseChildren = true;
					var j:int = c.numChildren;
					var i:int = 0;
					for (i; i < j; i++) {
						enableMouse(c.getChildAt(i));
					}
				}
			}
		}
		
		
		
		
		
	}

}