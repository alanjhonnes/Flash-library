package br.com.ajwebdesign.global {
	
	import flash.events.*;

	/**
	 * Global Events manager.
	 * @author Alan Jhonnes
	 */
	public class GlobalEvents extends EventDispatcher {
		
		private static var instance:GlobalEvents;
		
		public function GlobalEvents()
		{
			super();
			if( instance ){
				throw new Error("GlobalEvents can only be accessed through GlobalEvents.getInstance()");
			}
		}
		
		public static function birth():GlobalEvents		{
			if (instance == null) {
				instance = new GlobalEvents();
				trace("GlobalEvents initialized.");
			}
			return instance;
		}
		
		public override function dispatchEvent(event:Event):Boolean {
			return super.dispatchEvent(event);
		}
		
		public function dispatchCustomEvent(event:CustomEvent):void {
			this.dispatchEvent(event);
		}

		public static function getInstance():GlobalEvents {
			if (!instance) {
				throw new Error("GlobalEvents isn't initialized.");
			}
			return instance;
		}
	}
}