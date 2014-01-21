package br.com.ajwebdesign.ui.fullscreenbg 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class BackgroundEvent extends Event 
	{
		public static const IMAGE_READY:String = "IMAGE_READY";
		public static const LOADING:String = "LOADING";
		public static const BEFORE_TRANSITION_IN:String = "BEFORE_TRANSITION_IN";
		public static const TRANSITION_IN:String = "TRANSITION_IN";
		public static const AFTER_TRANSITION_IN:String = "AFTER_TRANSITION_IN";
		public static const BEFORE_TRANSITION_OUT:String = "BEFORE_TRANSITION_OUT";
		public static const TRANSITION_OUT:String = "TRANSITION_OUT";
		public static const AFTER_TRANSITION_OUT:String = "AFTER_TRANSITION_OUT";
		
		
		public function BackgroundEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new BackgroundEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("BackgroundEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}