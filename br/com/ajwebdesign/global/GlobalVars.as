package br.com.ajwebdesign.global 
{
	import flash.events.EventDispatcher;
	
	/**
	 * Global Variables singleton.
	 * @author Alan Jhonnes
	 */
	public class GlobalVars extends EventDispatcher
	{
		
		private static var instance:GlobalVars = new GlobalVars();
		
		private var _vars:Object = new Object();
		
		public function GlobalVars()
		{
			if (instance) {
				throw new Error("Use GlobalVars.getInstance() to access this class.");
			}
		}
		
		public function set vars(d:Object):void {
			for (var n in d) {
				_vars[n] = d[n];
			}
		}
		
		public function get vars():Object {
			return _vars;
		}
		
		static public function getInstance():GlobalVars { return instance; }
		
	}

}