package br.com.ajwebdesign.authentication 
{
	import flash.events.Event;
	
	/**
	 * Authentication Events used by UserAuth class.
	 * @author Alan
	 */
	public class AuthenticationEvent extends Event 
	{
		public static const LOGIN:String = "LOGIN";
		public static const LOGOUT:String = "LOGOUT";
		public static const LOGIN_ERROR:String = "LOGIN_ERROR";
		public static const READING_COOKIES:String = "READING_COOKIES";
		public static const	EDITING_USER:String = "EDITING_USER";
		public static const USER_EDITED:String = "USER_EDITED";
		public static const INSERTING_USER:String = "INSERTING_USER";
		public static const USER_INSERTED:String = "USER_INSERTED";
		public static const INSERT_ERROR:String = "INSERT_ERROR";
		public static const EDIT_ERROR:String = "EDIT_ERROR";
		
		public var message:String;
		
		public function AuthenticationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, message:String = "") 
		{ 
			super(type, bubbles, cancelable);
			this.message = message;
		} 
		
		public override function clone():Event 
		{ 
			return new AuthenticationEvent(type, bubbles, cancelable, message);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AuthenticationEvent", "type", "bubbles", "cancelable", "eventPhase", message); 
		}
		
	}
	
}