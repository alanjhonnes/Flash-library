package br.com.ajwebdesign.localization {
	
	
	public interface ILocalization {
		
		/**
		 * Function to handle language changes.
		 * @param	e
		 */
		function onLanguageChange(e:LanguageEvent = null):void;
		
	}
	
}