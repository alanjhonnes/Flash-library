package br.com.ajwebdesign.ui.components {
	import temple.core.CoreObject;
	/**
	 * Groups InputFields and monitor their status.
	 * @author Alan Jhonnes
	 */
	public class InputGroup extends CoreObject {
		
		protected var fields:Vector.<InputField> = new Vector.<InputField>();
		protected var _errors:Vector.<String>;
		
		protected var _invalidBgColor:uint;
		protected var _invalidTxtColor:uint;
		protected var _overBgColor:uint;
		protected var _validBgColor:uint;
		protected var _tweenDuration:Number = 0.3;
		
		override public function destruct():void {
			fields = null;
			_errors = null;
			super.destruct();
		}
		
		public function InputGroup(setFormatting:Boolean = false, invalidBgColor:uint = 0x000000, invalidTxtColor:uint = 0xFF0000, overBgColor:uint = 0x000000, validBgColor:uint = 0x000000, tweenDuration:Number = 0.3) {
			if (setFormatting) {
				setDefaulFormat(invalidBgColor, invalidTxtColor, overBgColor, validBgColor, tweenDuration);
			}
		}
		
		public function setDefaulFormat(invalidBgColor:uint, invalidTxtColor:uint, overBgColor:uint, validBgColor:uint, tweenDuration:Number):void {
			_invalidBgColor = invalidBgColor;
			_invalidTxtColor = invalidTxtColor;
			_overBgColor = overBgColor;
			_validBgColor = validBgColor;
			_tweenDuration = _tweenDuration;
		}
		
		public function validate():Boolean {
			var valid:Boolean = true;
			var j:int = fields.length;
			var field:InputField;
			_errors = new Vector.<String>();
			for (var i:int = 0; i < j; i++) {
				field = fields[i];
				if (!field.validate()) {
					_errors.push(field.errorMessage);
					valid = false;
				}
			}
			return valid;
		}
		
		public function get firstError():String {
			if (_errors) {
				if (_errors.length >= 1) {
					return _errors[0];
				}
			}
			return "";
		}
		
		public function get lastError():String {
			if (_errors) {
				var j:int = _errors.length;
				if (j >= 1) {
					return _errors[j -1];
				}
			}
			return "";
		}
		
		public function addField(field:InputField, addFormatting:Boolean = false):void {
			fields.push(field);
			if (addFormatting) {
				formatField(field);
			}
		}
		
		public function formatField(field:InputField):void {
			field.invalidBgColor = _invalidBgColor;
			field.invalidTxtColor = _invalidTxtColor;
			field.overBgColor = _overBgColor;
			field.validBgColor = _validBgColor;
			field.tweenDuration = _tweenDuration;
		}
		
		public function formatFields():void {
			var j:int = fields.length;
			for (var i:int = 0; i < j; i++) {
				formatField(fields[i]);
				fields[i].tabIndex = i;
			}
		}
		
		public function get errors():Vector.<String> {
			return _errors;
		}
		
	}

}