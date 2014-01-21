package br.com.ajwebdesign.ui.components {
	import com.greensock.TweenMax;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import temple.core.CoreSprite;
	import temple.utils.types.StringUtils;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class BaseField extends CoreSprite {
		
		public var txt:TextField;
		protected var _invalidTxtColor:uint;
		protected var _defaultText:String = "";
		protected var _minChars:int = 0;
		protected var _errorMessage:String = "";
		protected var _isInvalid:Boolean;
		protected var _validateFunction:Function;
		protected var _tweenDuration:Number = 0.3;
		
		override public function destruct():void {
			txt.removeEventListener(FocusEvent.FOCUS_IN, onTxtFocusIn);
			txt.removeEventListener(FocusEvent.FOCUS_OUT, onTxtFocusOut);
			super.destruct();
		}
		
		public function BaseField() {
			_defaultText = txt.text;
			txt.type = TextFieldType.INPUT;
			txt.addEventListener(FocusEvent.FOCUS_IN, onTxtFocusIn);
			txt.addEventListener(FocusEvent.FOCUS_OUT, onTxtFocusOut);
			_invalidTxtColor = txt.textColor;
		}
		
		
		protected function onTxtFocusIn(e:FocusEvent):void {
			if (text == _defaultText) {
				text = "";
			}
		}
		
		public function get remainingChars():int {
			if (maxChars != 0) {
				return maxChars - txt.text.length; 
			}
			return 0;
		}
		
		protected function onTxtFocusOut(e:FocusEvent):void {
			var text:String = txt.text;
			
			if (!StringUtils.hasText(text)) {
				this.text = _defaultText;
				idleState();
			}
			else {
				if (text == _defaultText) {
					idleState();
				}
				else if( validate()) {
					validState();
				}
				else {
					invalidState();
				}
			}
		}
		
		protected function validState():void {
			
		}
		
		protected function invalidState():void {
			TweenMax.to(txt, _tweenDuration, { tint: _invalidTxtColor } );
		}
		
		protected function idleState():void {
			txt.text = _defaultText;
			TweenMax.to(txt, _tweenDuration, { removeTint:true } );
		}
		
		public function validate():Boolean {
			var text = txt.text;
			if (text.length < _minChars) {
				return false;
			}
			else if (text == _defaultText) {
				return false;
			}
			else if (_validateFunction !== null) {
				return _validateFunction(text);
			}
			else {
				return true;
			}
		}
		
		public function reset():void {
			txt.text = _defaultText;
			
		}
		
		public function focus():void {
			if (stage) {
				stage.focus = txt;
			}
		}
		
		override public function get tabIndex():int {
			return txt.tabIndex;
		}
		
		override public function set tabIndex(value:int):void {
			txt.tabIndex = value;
		}
		
		public function get text():String {
			return txt.text;
		}
		
		public function set text(value:String):void {
			txt.text = value;
		}
		
		public function get errorMessage():String {
			return _errorMessage;
		}
		
		public function set errorMessage(value:String):void {
			_errorMessage = value;
		}
		
		public function get maxChars():int {
			return txt.maxChars;
		}
		
		public function set maxChars(value:int):void {
			txt.maxChars = value;
		}
		
		public function get minChars():int {
			return _minChars;
		}
		
		public function set minChars(value:int):void {
			_minChars = value;
		}
		
		public function get defaultText():String {
			return _defaultText;
		}
		
		public function set defaultText(value:String):void {
			_defaultText = value;
		}
		
		public function get invalidTxtColor():uint {
			return _invalidTxtColor;
		}
		
		public function set invalidTxtColor(value:uint):void {
			_invalidTxtColor = value;
		}
		
		public function get validateFunction():Function {
			return _validateFunction;
		}
		
		/* 
		 * A function used to validate the text. 
		 * Function signature should be function(value:String):Boolean  
		 */
		public function set validateFunction(value:Function):void {
			_validateFunction = value;
		}
		
		public function get tweenDuration():Number {
			return _tweenDuration;
		}
		
		public function set tweenDuration(value:Number):void {
			_tweenDuration = value;
		}
		
	}

}