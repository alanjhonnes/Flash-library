package br.com.ajwebdesign.games.memory.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class MemoryGameEvent extends Event {
		
		public static const DISPLAY_CARDS_COMPLETE:String = "displayCardsComplete";
		public static const COUNTDOWN:String = "countdown";
		public static const TIMEOUT:String = "timeout";
		public static const MATCH_CORRECT:String = "matchCorrect";
		public static const MATCH_INCORRECT:String = "matchIncorrect";
		public static const FINISH:String = "finish";
		
		public var data:*;
		
		public function MemoryGameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:* = null) { 
			super(type, bubbles, cancelable);
			this.data = data;
		} 
		
		public override function clone():Event { 
			return new MemoryGameEvent(type, bubbles, cancelable, data);
		} 
		
		public override function toString():String { 
			return formatToString("MemoryGameEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}