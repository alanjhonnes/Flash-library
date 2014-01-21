package br.com.ajwebdesign.ui.components {
	//import de.polygonal.ds.DLL;
	import flash.events.IEventDispatcher;
	import temple.core.CoreEventDispatcher;
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	[Event(name="allDeactivated", type="br.com.ajwebdesign.ui.components.ActiveEvent")]
	[Event(name="activated", type="br.com.ajwebdesign.ui.components.ActiveEvent")]
	public class ActiveGroup extends CoreEventDispatcher {
		
		protected var _objects:Vector.<IActive> = new Vector.<IActive>();
		protected var _currentActive:IActive;
		//protected var _currentActive:DLL;
		protected var _activeLimit:int;
		
		override public function destruct():void {
			var j:int = _objects.length;
			for (var i:int = 0; i < j; i++) {
				(_objects[i] as IEventDispatcher).removeEventListener(ActiveEvent.ACTIVATED, onObjectActivated);
				(_objects[i] as IEventDispatcher).removeEventListener(ActiveEvent.DEACTIVATED, onObjectDeactivated);
			}
			_objects = null;
			_currentActive = null;
			super.destruct();
		}
		
		public function ActiveGroup(activeLimit: int = 1) {
			_activeLimit = activeLimit;
			//_currentActive = new DLL(0, _activeLimit);
		}
		
		public function addActiveObject(obj:IActive):void {
			_objects.push(obj);
			if (obj.activated) {
				refreshGroup(obj);
			}
			(obj as IEventDispatcher).addEventListener(ActiveEvent.ACTIVATED, onObjectActivated);
			(obj as IEventDispatcher).addEventListener(ActiveEvent.DEACTIVATED, onObjectDeactivated);
		}
		
		private function refreshGroup(obj:IActive):void {
			
			if (obj.activated) {
				if (_currentActive) {
					if (_currentActive != obj) {
						_currentActive.deactivate();
						_currentActive = obj;
					}
					var j:int = _objects.length;
					for (var i:int = 0; i < j; i++) {
						obj = _objects[i];
						if (_currentActive != obj) {
							obj.deactivate();
						}
					}
				}
				else {
					_currentActive = obj;
				}
			}
			else {
				if (!_currentActive || _currentActive == obj) {
					_currentActive = null;
					dispatchEvent(new ActiveEvent(ActiveEvent.ALL_DEACTIVATED, false, false));
				}
			}
			
		}
		
		private function onObjectActivated(e:ActiveEvent):void {
			var obj:IActive = (e.currentTarget as IActive);
			refreshGroup(obj);
			dispatchEvent(new ActiveEvent(ActiveEvent.ACTIVATED, false, false, obj));
		}
		
		private function onObjectDeactivated(e:ActiveEvent):void {
			var obj:IActive = (e.currentTarget as IActive);
			refreshGroup(obj);
		}
		
		public function get currentActive():IActive {
			return _currentActive;
		}
		
		public function set currentActive(value:IActive):void {
			_currentActive = value;
			value.activate();
		}
		
		public function get objects():Vector.<IActive> {
			return _objects;
		}
		
		public function get activeLimit():int {
			return _activeLimit;
		}
		
		public function set activeLimit(value:int):void {
			_activeLimit = value;
		}
		
	}

}