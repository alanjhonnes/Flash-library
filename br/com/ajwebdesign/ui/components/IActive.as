package br.com.ajwebdesign.ui.components {
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public interface IActive {
		
		function get activated():Boolean;
		
		function activate():void;
		
		function deactivate():void;
		
		function toggle():void;
		
	}
	
}