package br.com.ajwebdesign.ui.components {
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import temple.core.CoreSprite;
	import temple.utils.types.StringUtils;
	
	/**
	 * An input textfield with a background
	 * @author Alan Jhonnes
	 */
	public class InputField extends BaseField {
		
		public var background:Sprite;
		protected var _invalidBgColor:uint;
		protected var _overBgColor:uint;
		protected var _validBgColor:uint;
		
		override public function destruct():void {
			
			super.destruct();
		}
		
		public function InputField() {
			super();
		}
		
		
		override protected function validState():void {
			TweenMax.to(background, _tweenDuration, { tint: _validBgColor } );
			super.validState();
		}
		
		override protected function invalidState():void {
			TweenMax.to(background, _tweenDuration, { tint: _invalidBgColor } );
			super.invalidState();
		}
		
		override protected function idleState():void {
			TweenMax.to(background, _tweenDuration, { removeTint:true } );
			super.idleState();
		}
		
		public function get invalidBgColor():uint {
			return _invalidBgColor;
		}
		
		public function set invalidBgColor(value:uint):void {
			_invalidBgColor = value;
		}
		
		public function get validBgColor():uint {
			return _validBgColor;
		}
		
		public function set validBgColor(value:uint):void {
			_validBgColor = value;
		}
		
		public function get overBgColor():uint {
			return _overBgColor;
		}
		
		public function set overBgColor(value:uint):void {
			_overBgColor = value;
		}
		
		
		
	}

}