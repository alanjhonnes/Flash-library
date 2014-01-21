package br.com.ajwebdesign.utils {
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class ObjectLogger{
		
		public static function log(obj:Object):void {
			if (obj) {
				trace("Tracing object properties...");
				var hasProp:Boolean = false;
				for (var name:String in obj) {
					trace(name + ": " + obj[name]);
					hasProp = true;
				}
				if (!hasProp) {
					trace("Object is empty.");
				}
			}
			else {
				trace( "object is null");
			}
		}
		
		public static function arrayLog(arr:Array, traceObjects:Boolean = false, depth:int = 0):void {
			trace("Tracing Array...");
			if (arr) {
				trace("depth: " + depth);
				var j:int = arr.length;
				if (j == 0) {
					trace("Array is empty.");
				}
				else {
					trace("Tracing array indexes:");
					for (var i:int = 0; i < j; i++) {
						var obj:* = arr[i];
						trace( "index " + i + ": " + arr[i]);
						if (obj is Array) {
							ObjectLogger.arrayLog(obj, traceObjects, depth);
						}
						else if ( traceObjects) {
							ObjectLogger.log(obj);
						}
					}
					depth++;
				}
				
			}
			else {
				trace( "Array is null");
			}
		}
		
	}

}