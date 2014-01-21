package br.com.ajwebdesign.ui.components {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class ActiveEvent extends Event {
		
		public static const ACTIVATED:String = "activated";
		public static const DEACTIVATED:String = "deactivated";
		public static const ALL_DEACTIVATED:String = "allDeactivated";
		
		public var object:IActive;
		
		public function ActiveEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, object:IActive = null) { 
			super(type, bubbles, cancelable);
			this.object = object;
		} 
		
		public override function clone():Event { 
			return new ActiveEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ActiveEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}