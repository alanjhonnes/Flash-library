package br.com.ajwebdesign.ui.components {
	import flash.events.MouseEvent;
	import temple.core.CoreMovieClip;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	[Event(name="activated", type="br.com.ajwebdesign.ui.components.ActiveEvent")]
	[Event(name="deactivated", type="br.com.ajwebdesign.ui.components.ActiveEvent")]
	public class ActiveButton extends CoreMovieClip implements IActive {
		
		protected var _activated:Boolean;
		protected var _mouseOver:Boolean;
		protected var _toggle:Boolean;
		
		public function ActiveButton(toggle:Boolean = false) {
			buttonMode = true;
			_toggle = toggle;
			addEventListener(MouseEvent.ROLL_OUT, onOut);
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		override public function destruct():void {
			removeEventListener(MouseEvent.ROLL_OUT, onOut);
			removeEventListener(MouseEvent.ROLL_OVER, onOver);
			removeEventListener(MouseEvent.CLICK, onClick);
			super.destruct();
		}
		
		public function get activated():Boolean {
			return _activated;
		}
		
		protected function onOut(e:MouseEvent):void {
			_mouseOver = false;
			if (!_activated) {
				normalState();
			}
		}
		
		protected function onOver(e:MouseEvent):void {
			_mouseOver = true;
			if (!_activated) {
				overState();
			}
		}
		
		protected function onClick(e:MouseEvent):void {
			if (_toggle) {
				toggle();
			}
			else {
				activate();
			}
		}
		
		public function activate():void {
			if (!_activated) {
				_activated = true;
				activeState();
				dispatchEvent(new ActiveEvent(ActiveEvent.ACTIVATED, true, false));
			}
		}
		
		public function deactivate():void {
			if (_activated) {
				_activated = false;
				if (_mouseOver) {
					overState();
				}
				else {
					normalState();
				}
				dispatchEvent(new ActiveEvent(ActiveEvent.DEACTIVATED, true, false));
			}
		}
		
		public function toggle():void {
			if (_activated) {
				deactivate();
			}
			else {
				activate();
			}
		}
		
		protected function activeState():void {
			
		}
		
		protected function normalState():void {
			
		}
		
		protected function overState():void {
			
		}
		
		
		
		
		
	}

}