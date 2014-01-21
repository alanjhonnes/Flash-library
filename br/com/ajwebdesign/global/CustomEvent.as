package br.com.ajwebdesign.global 
{
	import flash.events.*;
	import Object;
	
	/**
	 * Custom Events for the GlobalEvents manager.
	 * @author Alan Jhonnes
	 */
	public class CustomEvent extends Event 
	{
		
		//Place the custom event constants here.
		
		public static const SWF_ADDRESS:String = "swfAddress";
		
		public static const TRANSITION_COMPLETED:String = "transitionCompleted";
		
		public static const PAGE_COMPLETED:String = "pageCompleted";
		
		public static const LANGUAGE_CHANGE:String = "languageChange";
		
		public var value:*;
		
		public function CustomEvent(type:String, value:*, bubbles:Boolean=false, cancelable:Boolean=false ) 
		{ 
			super(type, bubbles, cancelable);
			this.value = value;
		} 
		
		
		public override function clone():Event 
		{ 
			return new CustomEvent(type, value, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CustomEvent", "type", "bubbles", "cancelable", "eventPhase", "state"); 
		}
		
	}
	
}