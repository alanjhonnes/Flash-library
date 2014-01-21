package br.com.ajwebdesign.authentication {
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public interface IUser {
		
		function get memberships():Vector.<String>;
		
		function doLogin():Boolean;
		
		function doLogout():Boolean;
		
		
	}
	
}