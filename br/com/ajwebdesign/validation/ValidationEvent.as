package br.com.ajwebdesign.validation 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alan
	 */
	public class ValidationEvent extends Event 
	{
		public static const ERROR:String = "ERROR";
		
		public var errorPT:String;
		public var errorEN:String;
		
		public function ValidationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, errorPT:String = "", errorEN = "" ) 
		{ 
			super(type, bubbles, cancelable);
			this.errorPT = errorPT;
			this.errorEN = errorEN;
		} 
		
		public override function clone():Event 
		{ 
			return new ValidationEvent(type, bubbles, cancelable, errorPT, errorEN);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ValidationEvent", "type", "bubbles", "cancelable", "eventPhase", errorPT, errorEN); 
		}
		
	}
	
}