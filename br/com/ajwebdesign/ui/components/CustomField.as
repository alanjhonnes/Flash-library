package br.com.ajwebdesign.ui.components 
{
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import fl.core.UIComponent;
	import flash.text.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import br.com.ajwebdesign.validation.Validation;
	import com.greensock.TweenMax;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class CustomField extends UIComponent
	{
		
		public var it:TextField;
		public var req:MovieClip;
		private var _defaultText:String = "";
		public var bg:MovieClip;
		private var _width:Number;
		private var _height:Number;
		private var xOffset:Number;
		private var yOffset:Number;
		
		public function CustomField(required:Boolean = false, defaultText:String = "") 
		{
			super();
			stop();
			req.visible = required;
			this.defaultText = defaultText;
			it.text = defaultText;
			it.type = TextFieldType.INPUT;
			this.it.addEventListener(FocusEvent.FOCUS_IN, focus);
			this.it.addEventListener(FocusEvent.FOCUS_OUT, out);
		}
		
		
		public function setSize(width:Number, height:Number):void {
			this._width = width;
			this._height = height;
			draw();
		}
		
		public function draw():void {
			
		}
		
		private function createChildren():void { 
			removeChildAt(0);
			
		}
		
		override protected function configUI():void 
		{
			super.configUI();
			
		}
		
		private function out(e:FocusEvent):void 
		{
			gotoAndStop(1);
			if (it.text == "") {
				it.text = defaultText;
			}
		}
		
		private function focus(e:FocusEvent):void 
		{
			if (it.text == defaultText) {
				it.text = "";
			}
			gotoAndStop(2);
		}
		
		public function set required(value:Boolean):void 
		{
			req.visible = value;
			
		}
		
		public function set defaultText(value:String):void 
		{
			_defaultText = value;
			if (it.text == "") {
				it.text = value;
			}
		}
		
		public function get defaultText():String { return _defaultText; }
		
	}

}