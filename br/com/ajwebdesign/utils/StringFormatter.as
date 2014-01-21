package  br.com.ajwebdesign.utils {
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class StringFormatter {
		
		public function StringFormatter() {
			
		}
		
		public static function toPercent(value:Number, decimals:int = 2, decimalSeparator:String = ",", usePrefix:Boolean = true):String {
			var result:String = value.toFixed(decimals);
			result = result.replace(".", decimalSeparator);
			if (usePrefix) {
				result += "%";
			}
			return result;
		}
		
		public static function toCurrency(value:Number, thousandSeparator:Boolean = true, prefix:Boolean = true, separator:String = ".", decimalSeparator:String = ",", currency:String = "R$"):String {
			var reais:int = Math.floor(value);
			var cents:String = value.toFixed(2).split(".")[1];
			var result:String;
			if (thousandSeparator) {
				var reaisArr:Array = [];
				var start:Number;
				var end:Number = String(reais).length;
				while (end > 0) {
					start = Math.max(end -3, 0);
					reaisArr.unshift(String(reais).slice(start, end));
					end = start;
				}
				result = reaisArr.join(separator) + decimalSeparator + cents;
			}
			else {
				result = reais + decimalSeparator + cents;
			}
			if (prefix) {
				result = currency + result;
			}
			return result;
		}
		
		public static function firstUpperCase(string:String):String {
			var lower:String = string.toLowerCase();
			var upper:String = lower.substring(0, 1).toUpperCase();
			return upper + lower.substr(1);
		}
		
		public static function leftTrim(input:String):String {
			var size:Number = input.length;
			for(var i:Number = 0; i < size; i++)
			{
				if(input.charCodeAt(i) > 32)
				{
					return input.substring(i);
				}
			}
			return "";
		}
		
		public static function rightTrim(input:String):String
		{
			var size:Number = input.length;
			for(var i:Number = size; i > 0; i--)
			{
				if(input.charCodeAt(i - 1) > 32)
				{
					return input.substring(0, i);
				}
			}

			return "";
		}
		
		public static function trim(input:String):String
		{
			return StringFormatter.leftTrim(StringFormatter.rightTrim(input));
		}
		
		
	}

}