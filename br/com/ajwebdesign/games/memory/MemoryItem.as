package br.com.ajwebdesign.games.memory {
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import org.bytearray.tools.events.FlippedEvent;
	import org.bytearray.tools.SideDetector;
	import temple.core.CoreSprite;
	
	/**
	 * Base class for memory game items
	 * @author Alan Jhonnes
	 */
	public class MemoryItem extends CoreSprite {
		
		private var _match:MemoryItem;
		private var _isUp:Boolean = false;
		private var cover:Sprite;
		private var card:Sprite;
		private var sideDetector:SideDetector;
		
		private var _matched:Boolean = false;
		private var hasQueuedFlip:Boolean = false;
		
		private var _itemClass:Class;
		private var _coverClass:Class;
		
		public var onFlipUp:Function; 
		public var onFlipDown:Function;
		public var onMatch:Function;
		
		override public function destruct():void {
			_match = null;
			cover = null;
			card = null;
			sideDetector.removeEventListener(FlippedEvent.FLIPPED, onFlipped);
			sideDetector.destruct();
			sideDetector = null;
			_itemClass = null;
			_coverClass = null;
			super.destruct();
		}
		
		public function MemoryItem(item:Class, CoverClass:Class, flipUpCallback:Function = null, flipDownCallback:Function = null, matchCallback:Function = null) {
			_itemClass = item;
			_coverClass = CoverClass;
			cover = new _coverClass();
			card = new _itemClass();
			addChild(card);
			addChild(cover);
			card.visible = false;
			buttonMode = true;
			sideDetector = new SideDetector(this, false);
			sideDetector.addEventListener(FlippedEvent.FLIPPED, onFlipped);
			sideDetector.startDetecting();
			if (flipUpCallback is Function) {
				onFlipUp = flipUpCallback;
			}
			else {
				onFlipUp = defaultFlipUp;
			}
			if (flipDownCallback is Function) {
				onFlipDown = flipDownCallback;
			}
			else {
				onFlipDown = defaultFlipDown;
			}
			if (matchCallback is Function) {
				onMatch = matchCallback;
			}
			else {
				onMatch = defaultMatch;
			}
		}
		
		/**
		 * Creates a duplicate match of the card,setting this cards properties and the duplicate.
		 * @return
		 */
		public function createAndSetMatch():MemoryItem {
			if (!match) {
				var returnMatch:MemoryItem = new MemoryItem( itemClass, coverClass, onFlipUp, onFlipDown, onMatch );
				returnMatch.match = this;
				match = returnMatch;
				return returnMatch;
			}
			return null;
		}
		
		//override to change flip properties
		protected function onFlipped(e:FlippedEvent):void {
			if (e.position == SideDetector.BACKFACE) {
				cover.visible = false;
				card.visible = true;
			}
			else {
				cover.visible = true;
				card.visible = false;
			}
		}
		
		public function flip():void {
			if (_isUp) {
				flipDown();
			}
			else {
				flipUp();
			}
		}
		
		/**
		 * Override to add custom animation
		 */
		public function flipUp():void {
			//sideDetector.startDetecting();
			_isUp = true;
			onFlipUp.apply(this);
			//hasQueuedFlip = false;
		}
		
		
		
		/**
		 * Override to add custom animation
		 */
		public function flipDown():void {
			//sideDetector.startDetecting();
			_isUp = false;
			onFlipDown.apply(this);
			
			hasQueuedFlip = false;
		}
		
		private function defaultFlipUp():void {
			TweenMax.to( this, 0.4, { rotationY:180 } );
		}
		
		private function defaultFlipDown():void {
			TweenMax.to( this, 0.4, { rotationY:0 } );
		}
		
		private function defaultMatch():void {
			TweenMax.to(this, 0.4, { glowFilter: { color:0x005288, alpha:1, blurX:16, blurY:16, strength:3 }, colorMatrixFilter:{ contrast:1.3 } } );
		}
		
		public function queueFlipDown(seconds:Number = 0.8):void {
			hasQueuedFlip = true;
			TweenMax.delayedCall( seconds, onQueuedFlipDown);
		}
		
		private function onQueuedFlipDown():void {
			if (hasQueuedFlip) {
				flipDown();
			}
		}
		
		public function get match():MemoryItem {
			return _match;
		}
		
		public function set match(value:MemoryItem):void {
			_match = value;
		}
		
		public function get matched():Boolean {
			return _matched;
		}
		
		public function set matched(value:Boolean):void {
			_matched = value;
			onMatch.call(this);
		}
		
		public function get itemClass():Class {
			return _itemClass;
		}
		
		public function get coverClass():Class {
			return _coverClass;
		}
		
	}

}