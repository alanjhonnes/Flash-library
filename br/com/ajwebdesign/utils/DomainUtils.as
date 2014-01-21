package br.com.ajwebdesign.utils {
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.Security;
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class DomainUtils {
		
		public static function get isLocal():Boolean {
			return Security.sandboxType != Security.REMOTE;
		}
		
		public static function get isInBrowser():Boolean 
		{
			return (Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX");
		}
		
		/**
		 * getSwfPath is used to return the folder where the SWF is hosted.
		 * 
		 * @param root The root of your SWF.
		 */
		public static function getSwfPath(root:Sprite):String
		{
			var uri:String = root.loaderInfo.loaderURL;
			return uri.substring(0, uri.lastIndexOf("/")) + "/";
		}
		
		public static function get DOMAIN():String
		{
			var localConnection:LocalConnection = new LocalConnection();
			var domain:String = localConnection.domain;
			localConnection = null;
			return domain;
		}
		
	}

}