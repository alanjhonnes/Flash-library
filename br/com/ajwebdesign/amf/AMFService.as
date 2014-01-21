package br.com.ajwebdesign.amf {
	import br.com.ajwebdesign.utils.DomainUtils;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.net.LocalConnection;
	import flash.net.NetConnection;
	
	/**
	 * Helper for AMF services
	 * @author Alan Jhonnes
	 */
	public class AMFService extends EventDispatcher  {
		
		private static var _path:String;
		private static var _alternativePath:String;
		private static var _relativeGatewayPath:String;
		
		public function AMFService(root:Sprite, relativeGatewayPath:String = "amf/gateway.php", alternativePath:String = "http://localhost/") {
			_path = DomainUtils.getSwfPath(root);
			_relativeGatewayPath = relativeGatewayPath;
			_alternativePath = alternativePath;
		}
		
		static public function get correctGatewayPath():String {
			var correctPath:String;
			if (DomainUtils.isInBrowser) {
				correctPath =  _path + _relativeGatewayPath;
			}
			else {
				correctPath =  _alternativePath + _relativeGatewayPath;
			}
			return correctPath;
		}
		
		static public function get relativeGatewayPath():String {
			return _relativeGatewayPath;
		}
		
		static public function set relativeGatewayPath(value:String):void {
			_relativeGatewayPath = value;
		}
		
		static public function get alternativePath():String {
			return _alternativePath;
		}
		
		static public function set alternativePath(value:String):void {
			_alternativePath = value;
		}
		
		static public function get path():String {
			return _path;
		}
		
		static public function set path(value:String):void {
			_path = value;
		}
		
		public static function setPath(root:Sprite):void {
			_path = DomainUtils.getSwfPath(root);
		}
		
	}

}