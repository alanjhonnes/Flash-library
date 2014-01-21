package br.com.ajwebdesign.ui.scrollers {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import temple.core.CoreMovieClip;
	import temple.core.CoreSprite;
	import temple.ui.buttons.MultiStateButton;
	import flash.ui.Keyboard;
	
	
	/**
	 * Scrollbar class.
	 * @author Alan Jhonnes
	 */
	public class Scroller extends CoreMovieClip {
		
		//graphics
		public var yScrubber:MultiStateButton;
		public var yBar:MovieClip;
		
		//properties
		//the target to be scrolled
		protected var _target:DisplayObject;
		//width limit, if not set it adapts the stage width as the limit.
		protected var _width:Number;
		//height limit, if not set it adapts the stage height as the limit.
		protected var _height:Number;
		protected var _smoothScrolling:Boolean;
		//a sprite to mask the container movieclip.
		protected var masker:Sprite = new Sprite();
		//an empty sprite to hold target 
		protected var container:Sprite = new Sprite();
		private var isDragging:Boolean;
		
		// % of the yScrubber horizontal location in relation to the scrollbar
		protected var percX:Number;
		
		// % of the yScrubber vertical location in relation to the scrollbar
		protected var percY:Number;
		
		/**
		 * 
		 * @param	target
		 * @param	width
		 * @param	height
		 * @param	smoothScrolling
		 * @param   useMask
		 */
		public function Scroller(target:DisplayObject, width:Number, height:Number, smoothScrolling:Boolean = true, useMask:Boolean = true) {
			_target = target;
			_smoothScrolling = smoothScrolling;	
			_width = width;
			_height = height;
			addChild(container);
			addChild(yBar);
			addChild(yScrubber);
			if (useMask) {
				drawMasker();
				addChild(masker);
				container.mask = masker;
			}
			_target.x = _target.y = 0;
			//position the scrollbar to the right of the target.
			yBar.x = width;
			yScrubber.x = width;
			//resizes the scrollbar to fit the area.
			yBar.height = height;
			container.addChild(_target);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			yScrubber.addEventListener(MouseEvent.MOUSE_DOWN, onYScrubberMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onYScrubberMouseUp);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
			update();
		}
		
		private function drawMasker():void {
			masker.graphics.clear();
			masker.graphics.beginFill(0xFFFFFF);
			masker.graphics.moveTo(0, 0);
			masker.graphics.lineTo(_width, 0);
			masker.graphics.lineTo(_width, _height);
			masker.graphics.lineTo(0, _height);
			masker.graphics.lineTo(0, 0);
			masker.graphics.endFill();
		}
		
		public function update():void {
			//display horizontal scrollbar
			if (container.width > _width) {
				//TODO
			}
			//display vertical scrollbar
			if (container.height > _height) {
				yScrubber.height = _height * _height / _target.height;
				//resize the scrollbar
				yBar.height = _height;
				yBar.x = _width - yBar.width;
				yScrubber.x = _width - yScrubber.width;
				
				
				
				//if its hidden,show it
				if (this.alpha < 1) TweenLite.to(this, 0.4, { autoAlpha:1 } );
				
			}
			else {
				TweenLite.to(this, 0.4, { autoAlpha:0 } );
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case Keyboard.DOWN : {
					
				}
				case Keyboard.UP : {
					
				}
				case Keyboard.LEFT : {
					
				}
				case Keyboard.RIGHT : {
					
				}
			}
		}
		
		private function onYScrubberMouseUp(e:MouseEvent):void {
			if (isDragging) {
				yScrubber.stopDrag();
				isDragging = false;
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onYScrubberMouseMove);
			}
		}
		
		private function onYScrubberMouseDown(e:MouseEvent):void {
			//the rectangle has no width so the yScrubber cant be dragged horizontally,and we remove the yScrubber's height to avoid dragging it outside the scrollbar boundaries.
			yScrubber.startDrag(false, new Rectangle(_width - yBar.width, 0, 0, yBar.height - yScrubber.height*0.97));
			isDragging = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onYScrubberMouseMove);
			stage.addEventListener(Event.MOUSE_LEAVE, onYScrubberMouseLeave);
		}
		
		private function onYScrubberMouseLeave(e:Event):void {
			if (stage.hasEventListener(MouseEvent.MOUSE_MOVE)) stage.removeEventListener(MouseEvent.MOUSE_MOVE, onYScrubberMouseMove);
			stage.removeEventListener(Event.MOUSE_LEAVE, onYScrubberMouseLeave);
		}
		
		private function onYScrubberMouseMove(e:MouseEvent):void {
			percY = (yScrubber.y * 100) / (yBar.height - yScrubber.height);
			scrollY(percY);
			dispatchEvent(new ScrollerEvent(ScrollerEvent.SCROLL, percY, ScrollerEvent.VERTICAL));
		}
		
		private function scrollY(percentage:Number):void {
			var yRatio:Number = _target.height / _height;
			var heightPerc:Number = _height * 0.01;
			var yPos:Number = percY * (yRatio * heightPerc - heightPerc);
			if (smoothScrolling) {
				TweenLite.to(_target, 0.4, { y:-yPos, ease:Quad } );
			}
			else {
				_target.y = -yPos;
			}
		}
		
		private function scrollX(percentage:Number):void {
			var xRatio:Number = _target.width / _width;
			var widthPerc:Number = _width * 0.01;
			var xPos:Number = percX * (xRatio * widthPerc - widthPerc);
			if (smoothScrolling) {
				TweenLite.to(_target, 0.4, { x:-xPos, ease:Quad } );
			}
			else {
				_target.x = -xPos;
			}
		}
		
		private function onMouseWheelHandler(e:MouseEvent) { 
			var delta:int = e.delta;
		} 
		
		public function get target():DisplayObject { return _target; }
		
		public function get smoothScrolling():Boolean { return _smoothScrolling; }
		
		public function set smoothScrolling(value:Boolean):void {
			_smoothScrolling = value;
		}	
		
		override public function set height(value:Number):void {
			_height = value;
			drawMasker();
			update();
		}
		
		override public function set width(value:Number):void {
			_width = value;
			drawMasker();
			update();
		}
		
		public function size(width:Number, height:Number):void {
			_width = width;
			_height = height;
			drawMasker();
			update();
		}
		
	}

}