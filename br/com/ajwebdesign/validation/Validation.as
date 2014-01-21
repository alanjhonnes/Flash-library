package br.com.ajwebdesign.validation 
{
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Alan
	 */
	public class Validation extends EventDispatcher
	{
		public static var pattern:RegExp;
		protected static var errorPT:String;
		protected static var errorEN:String;
		
		public function Validation() { }
		
		public static function email(email:String):Boolean {
			//pattern = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/;
			pattern = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			errorPT = "Email inválido.";
			errorEN = "Email is invalid.";
			return pattern.test(email);
		}
		
		public static function cep(cep:String):Boolean {
			pattern = /^[0-9]{5}-[0-9]{3}$/;
			return pattern.test(cep);
		}
		
		
		
		public static function ip(ip:String):Boolean {
			//pattern = new RegExp("\b(?:\d{1,3}\.){3}\d{1,3}\b");
			pattern = /\b(?:\d{1,3}\.){3}\d{1,3}\b/;
			return pattern.test(ip);
		}		
	}

}
