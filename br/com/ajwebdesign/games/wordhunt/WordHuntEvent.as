package br.com.ajwebdesign.games.wordhunt {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class WordHuntEvent extends Event {
		
		public static const SELECTION_START:String = "selectionStart";
		public static const SELECTION_END:String = "selectionEnded";
		public static const DIRECTION_SET:String = "directionSet";
		public static const WORD_FOUND:String = "wordFound";
		public static const UPDATE:String = "update";
		public static const CHANGE:String = "change";
		
		public var id:int;
		public var selections:Vector.<int>;
		public var direction:int;
		public var location:int;
		
		public function WordHuntEvent(type:String, id:int = 0, possibleSelections:Vector.<int> = null, direction:int = 0, location:int = 4,  bubbles:Boolean = false, cancelable:Boolean = false ) { 
			super(type, bubbles, cancelable);
			this.id = id;
			this.direction = direction;
			this.location = location;
			selections = possibleSelections;
		}
		
		public override function clone():Event { 
			return new WordHuntEvent(type, id, selections, direction, location, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("WordHuntEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}