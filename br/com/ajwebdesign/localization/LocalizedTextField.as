package br.com.ajwebdesign.localization {
	import br.com.ajwebdesign.localization.LanguageEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * This class makes easy management of localized text fields.
	 * @author Alan Jhonnes
	 */
	public class LocalizedTextField extends TextField {
		
		protected var _texts:Array = [];
		protected var currentIndex:int = 0;
		
		public function LocalizedTextField() {
			this.loaderInfo.addEventListener(Event.UNLOAD, onUnload);
			if (LanguageManager.getInstance()) {
				LanguageManager.getInstance().addEventListener(LanguageEvent.LANGUAGE_CHANGE, onLanguageChange);
			}
			else {
				trace("[ " + this.name + " ] LanguageManager isn't initialized, defaulting to first language.");
			}
		}
		
		private function onUnload(e:Event):void {
			
		}
		
		private function onLanguageChange(e:LanguageEvent):void {
			currentIndex = e.languageIndex;
			this.text = _texts[currentIndex];
		}
		
		public function get texts():Array { return _texts; }
		
		public function set texts(value:Array):void {
			_texts = value;
			this.text = _texts[currentIndex];
		}
		
	}

}