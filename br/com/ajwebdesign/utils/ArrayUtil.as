package br.com.ajwebdesign.utils {
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class ArrayUtil {
		
		
		/**
		 * 
		 * @param	array
		 * @return A new array with the inverted values without modifying the original one.
		 */
		public static function invertArray(array:Array):Array {
			var i:int = array.length -1;
			var newArray:Array = [];
			var j:int = 0;
			while (i--) {
				newArray[j] = array[i];
				j++;
			}
			return newArray;
		}
		
	}

}