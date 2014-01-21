package br.com.ajwebdesign.authentication {
	import temple.core.CoreObject;
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class BaseUser extends CoreObject {
		
		protected var _memberships:Vector.<String> = new Vector.<String>();
		
		protected var _isAuthenticated:Boolean = false;
		
		public var login:String = "";
		public var userId:int = -1;
		public var email:String;
		
		public function BaseUser() {
			
		}
		
		public function addMembership(membership:String):void {
			if (!hasMembership(membership)) {
				_memberships.push(membership);
			}
		}
		
		public function removeMembership(membership:String):void {
			var i:int = 0;
			var j:int = _memberships.length;
			for (i; i < j; i++) {
				if (membership == _memberships[i]) {
					_memberships.splice(i, 1);
				}
			}
		}
		
		public function hasMembership(membership:String):Boolean {
			var i:int = 0;
			var j:int = _memberships.length;
			for (i; i < j; i++) {
				if (membership == _memberships[i]) {
					return true;
				}
			}
			return false;
		}
		
		public function get memberships():Vector.<String> {
			return _memberships;
		}
		
		public function get isAuthenticated():Boolean {
			return _isAuthenticated;
		}
		
	}

}