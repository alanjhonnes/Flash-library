package br.com.ajwebdesign.ui.components {
	import com.greensock.BlitMask;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import temple.core.CoreSprite;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class BlitScrollbar extends CoreSprite {
		
		public var blitMask:BlitMask;
		public var scrubber:Sprite;
		public var scrollRectangle:Rectangle;
		
		public var scrollArea:Sprite;
		
		public var scrollHeight:Number;
		public var scrubberHeight:Number;
		
		public function BlitScrollbar(blitMask:BlitMask, height:Number) {
			this.blitMask = blitMask;
			blitMask.parent.addChild(this);
			scrubberHeight = scrubber.height;
			
			scrubber.buttonMode = true;
			scrubber.addEventListener(MouseEvent.MOUSE_DOWN, onScrubberMouseDown);
			scrollArea.height = height;
			scrollRectangle = new Rectangle(scrubber.x, 0, 0, blitMask.height - scrubberHeight);
			updateSize();
			updatePosition();
		}
		
		public function updatePosition():void {
			this.x = blitMask.width + blitMask.x;
			this.y = blitMask.y;
		}
		
		public function updateSize():void {
			scrubberHeight = scrubber.height;
			scrollRectangle.height = blitMask.height - scrubberHeight;
			scrollHeight = scrollArea.height - scrubberHeight;
			//scrollArea.height = blitMask.height;
			if (blitMask.target.height < blitMask.height) {
				TweenMax.to(this, 0.3, { autoAlpha:  0} );
			}
			else {
				TweenMax.to(this, 0.3, { autoAlpha:  1} );
			}
		}
		
		private function onScrubberMouseDown(e:MouseEvent):void {
			scrubber.startDrag(false, scrollRectangle);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		private function onEnterFrame(e:Event):void {
			blitMask.scrollY = scrubber.y / scrollHeight;
		}
		
		private function onStageMouseUp(e:MouseEvent):void {
			scrubber.stopDrag();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}
		
		public function update():void {
			
		}
		
		public function updateBlitMask(forceRecapture:Boolean = false):void {
			blitMask.update(null, forceRecapture);
			update();
		}
		
		override public function destruct():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			super.destruct();
		}
		
	}

}