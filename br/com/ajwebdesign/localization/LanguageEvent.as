package br.com.ajwebdesign.localization {
	import flash.events.Event;
	
	public class LanguageEvent extends Event{
		
		public var language:String;
		public var languageIndex:int;
		
		public static const LANGUAGE_CHANGE:String = "languageChange";
		public static const DEFAULT_LANGUAGE_FOUND:String = "defaultLanguageFound";
		
		public function LanguageEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, language:String = "pt", languageIndex:int = 0) {
			super(type, bubbles, cancelable);
			this.language = language;
		}
		
	}

}