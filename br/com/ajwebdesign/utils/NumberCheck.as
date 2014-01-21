package br.com.ajwebdesign.utils {
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class NumberCheck {
		
		public function NumberCheck() {
			
		}
		
		public static function getNumber(number:Number):Number {
			if (isNaN(number) || !isFinite(number)) {
				return 0;
			}
			return number;
		}
		
	}

}