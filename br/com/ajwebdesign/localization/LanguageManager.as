package br.com.ajwebdesign.localization {
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	
	/**
	 * Dispatched when the language is changed.
	 * @eventType br.com.ajwebdesign.localization.LanguageEvent.LANGUAGE_CHANGE
	 */
	[Event(name="languageChange", type="br.com.ajwebdesign.localization.LanguageEvent")] 
	
	/**
	 * Class that handles the language changes.
	 * @usage Instantiate the class in the Index page in order to be able to access the language asset.
	 * @author Alan Jhonnes
	 */
	public class LanguageManager extends EventDispatcher {
		private static var instance:LanguageManager;
		
		private var cookies:SharedObject = SharedObject.getLocal("languages");
		
		public static const PORTUGUESE:String = "pt";
		public static const ENGLISH:String = "en";
		public static const SPANISH:String = "es";
		
		public static const LANGUAGES:Array = [PORTUGUESE, ENGLISH, SPANISH];
		
		private var _language:String = "pt";
		private var _languageIndex:int = 0;
		
		private var _xml:XML;
		
		/**
		 * The XML should be structured like this:
		 * <languages>
		 *    <language name="pt">
		 *        <page name="PageClassName">
		 *             //all custom nodes here
		 *        </page>
		 *    </language>
		 * </languages>
		 */
		
		public function LanguageManager() {
			super();
			if( instance ){
				throw new Error("LanguageManager can only be accessed through LanguageManager.getInstance()");
			}
			else {
				trace("LanguageManager initialized.");
				if (cookies.data.language) {
					_language = cookies.data.language;
					trace("Default language found:" + _language);
					dispatchEvent(new LanguageEvent(LanguageEvent.DEFAULT_LANGUAGE_FOUND, false, false, _language));
				}
			}
		}
		
		public static function birth(languagesXML:XML = null):LanguageManager	{
			if (!instance) {
				instance = new LanguageManager();
				if (languagesXML) {
					instance.xml = languagesXML;
				}
			}
			else {
				trace("LanguageManager already initialized.");
			}
			return instance;
		}
		
		public static function getInstance():LanguageManager {
			if (!instance) {
				throw new Error("LanguageManager isn't initialized.");
			}
			return instance;
		}
		
		/**
		 * Get the page element according to the current language.
		 * @param	pageName The name of the page to search for.
		 * @return A XMLList containing a page element of the current language.
		 */
		public function getPageXML(pageName:String):XMLList {
			return xml.language.(@name == _language).page.(@name == pageName);
		}
		
		/**
		 * Gets all XML nodes containing this page name. Can be used along with LocalizedTextFields to set theis texts property. 
		 * @param	pageName The name of the page to search for.
		 * @return A XMLList containing all the page nodes found.
		 */
		public function getAllPageXML(pageName:String):XMLList {
			return xml.language.page.(@name == pageName);
		}
		/**
		 * Returns the current language being used.
		 */
		public function get language():String { return _language; }
		
		/**
		 * Sets the language to be used.
		 */
		public function set language(value:String):void {
			if (_language != value) {
				_language = value;
				cookies.data.language = value;
				dispatchEvent(new LanguageEvent(LanguageEvent.LANGUAGE_CHANGE, false, false, value));
				var j:int = LANGUAGES.length;
				for (var i:int = 0; i < j; i++) {
					if (_language == LANGUAGES[i]) {
						_languageIndex = i;
						//if language was found then exit the loop
						continue;
					}
				}
			}
		}
		
		
		/**
		 * Returns the whole XML being used.
		 */
		public function get xml():XML { return _xml; }
		
		/**
		 * Sets the XML for the LanguageManager. It should be structured like this:
		 *  <languages>
		 *    <language name="pt">
		 *        <page name="PageClassName">
		 *             //all custom nodes here
		 *        </page>
		 *    </language>
		 * </languages>
		 */
		public function set xml(value:XML):void {
			_xml = value;
		}
		
		/**
		 * Gets the current language index.
		 */
		public function get languageIndex():int { return _languageIndex; }
		
		/**
		 * Sets the language index.
		 */
		public function set languageIndex(value:int):void {
			_languageIndex = value;
			language = LANGUAGES[_languageIndex];
		}
		
	}

}