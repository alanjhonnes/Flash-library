package br.com.ajwebdesign.ui.scrollers {
	import flash.events.Event;
	
	/**
	 * Scroller Event Class.
	 * @author Alan Jhonnes
	 */
	public class ScrollerEvent extends Event {
		
		//event types
		public static const SCROLL = "scroll";
		public static const MOUSE_WHEEL = "mouseWheel";
		
		//scroll types
		public static const VERTICAL = "vertical";
		public static const HORIZONTAL = "horizontal";
		
		//properties
		public var scrollType:String;
		public var position:Number;
		public var delta:Number;
		
		public function ScrollerEvent(type:String, position:Number,scrollType:String = ScrollerEvent.VERTICAL, bubbles:Boolean=false, cancelable:Boolean=false ) { 
			super(type, bubbles, cancelable);
			
		} 
		
		/*
		public override function clone():Event { 
			return new ScrollerEvent(type, bubbles, cancelable);
		} 
		*/
		
		public override function toString():String { 
			return formatToString("ScrollerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}