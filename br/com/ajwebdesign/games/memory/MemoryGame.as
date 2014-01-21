package br.com.ajwebdesign.games.memory {
	import br.com.ajwebdesign.games.memory.events.MemoryGameEvent;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.errors.MemoryError;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import temple.core.CoreEventDispatcher;
	import temple.core.CoreSprite;
	import hype.extended.layout.GridLayout;
	import be.nascom.flash.util.ArrayUtil;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	[Event(name="countdown", type="br.com.ajwebdesign.games.memory.events.MemoryGameEvent")]
	[Event(name="timeout", type="br.com.ajwebdesign.games.memory.events.MemoryGameEvent")]
	[Event(name = "matchCorrect", type = "br.com.ajwebdesign.games.memory.events.MemoryGameEvent")]
	[Event(name="matchIncorrect", type="br.com.ajwebdesign.games.memory.events.MemoryGameEvent")]
	[Event(name="finish", type="br.com.ajwebdesign.games.memory.events.MemoryGameEvent")]
	[Event(name="displayCardsComplete", type="br.com.ajwebdesign.games.memory.events.MemoryGameEvent")]
	public class MemoryGame extends CoreSprite {
		
		public var selectedItem:MemoryItem;
		public var items:Array;
		public var matches:Array;
		
		private var xml:XML;
		private var _isPlaying:Boolean;
		private var timer:Timer;
		private var _timeLimit:int;
		
		private var layout:GridLayout;
		private var hSpacing:int;
		private var vSpacing:int;
		private var columns:int;
		private var memoryItems:Array;
		private var cover:Class;
		
		//all shuffled cards
		private var shuffled:Array;
		
		private var activeCards:int = 0;
		private var activeCard1:MemoryItem;
		private var activeCard2:MemoryItem;
		private var lastClicked:MemoryItem;
		
		private var _timeRemainning:Number;
		private var _totalMatchs:int;
		private var _totalMatched:int;
		
		private var _flipUpCallback:Function;
		private var _flipDownCallback:Function;
		private var _matchCallback:Function;
		
		override public function destruct():void {
			selectedItem = null;
			items = [];
			matches = [];
			if (timer) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTick);
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
			}
			layout = null;
			memoryItems = [];
			shuffled = [];
			activeCard1 = null;
			activeCard2 = null;
			lastClicked = null;
			super.destruct();
		}
		
		public function MemoryGame() {
			
		}
		
		public function xmlSetup(xml:XML):void {
			this.xml  = xml;
			_timeLimit = xml.@timelimit;
			hSpacing = xml.@hSpacing;
			vSpacing = xml.@vSpacing;
			columns = xml.@columns;
			init();
		}
		
		public function setup(ClassArray:Array, coverClass:Class, timelimit:int = 60, hSpacing:Number = 200, vSpacing:Number = 300, columns:int = 5, flipUpCallback:Function = null, flipDownCallback:Function = null, matchCallback:Function = null ):void {
			items = ClassArray;
			cover = coverClass;
			_timeLimit = timelimit;
			_totalMatchs = items.length;
			this.hSpacing = hSpacing;
			this.vSpacing = vSpacing;
			this.columns = columns;
			_flipUpCallback = flipUpCallback;
			_flipDownCallback = flipDownCallback;
			_matchCallback = matchCallback;
			init();
		}
		
		private function init():void {
			layout = new GridLayout(hSpacing * 0.5, vSpacing * 0.5, hSpacing, vSpacing, columns);
			var l:int = items.length;
			shuffled = [];
			for (var k:int = 0; k < l; k++) {
				var item:MemoryItem = new MemoryItem(items[k], cover, _flipUpCallback, _flipDownCallback, _matchCallback);
				var match:MemoryItem = item.createAndSetMatch();
				shuffled.push(item, match);
			}
			shuffled = ArrayUtil.shuffle(shuffled);
			var j:int = shuffled.length;
			for (var i:int = 0; i < j; i++) {
				item = shuffled[i];
				layout.applyLayout(item);
				addChild(item);
			}
			timer = new Timer(1000, _timeLimit);
			timer.addEventListener(TimerEvent.TIMER, onTick);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
		}
		
		private function onTick(e:TimerEvent):void {
			dispatchEvent( new MemoryGameEvent(MemoryGameEvent.COUNTDOWN, false, false));
			_timeRemainning--;
		}
		
		public function displayCards(seconds:Number = 4):void {
			var i:int = 0;
			var j:int = shuffled.length;
			var item:MemoryItem;
			var delay:Number
			for (i; i < j; i++) {
				item = shuffled[i];
				delay = i * 0.2;
				TweenMax.delayedCall( delay, MemoryItem(shuffled[i]).flipUp );
				item.queueFlipDown(seconds + delay);
			}
			TweenMax.delayedCall(delay + seconds + 0.4, function():void { dispatchEvent(new MemoryGameEvent(MemoryGameEvent.DISPLAY_CARDS_COMPLETE, false, false)) } );
		}
		
		public function startGame():void {
			_timeRemainning = timeLimit;
			timer.start();
			var i:int = 0;
			var j:int = shuffled.length;
			for (i; i < j; i++) {
				Sprite(shuffled[i]).addEventListener(MouseEvent.CLICK, onCardClicked);
			}
		}
		
		private function onCardClicked(e:MouseEvent):void {
			var card:MemoryItem = MemoryItem(e.currentTarget);
			if (lastClicked == card) {
				card.flipDown();
				lastClicked = null;
				activeCards = 0;
				activeCard1 = null;
				activeCard2 = null;
			}
			else {
				card.flip();
				lastClicked = card;
				if (activeCards == 0) {
					activeCard1 = card;
					activeCards++;
				}
				else {
					activeCard2 = card;
					activeCards = 0;
					if ( activeCard1.match == activeCard2) {
						activeCard1.matched = true;
						activeCard2.matched = true;
						activeCard1.flipUp();
						activeCard2.flipUp();
						activeCard1.removeEventListener(MouseEvent.CLICK, onCardClicked);
						activeCard2.removeEventListener(MouseEvent.CLICK, onCardClicked);
						_totalMatched++;
						dispatchEvent(new MemoryGameEvent(MemoryGameEvent.MATCH_CORRECT, false, false, activeCard1.itemClass));
						if (_totalMatched == _totalMatchs) {
							gameFinished();
						}
						activeCard1 = null;
						activeCard2 = null;
					}
					else {
						dispatchEvent(new MemoryGameEvent(MemoryGameEvent.MATCH_INCORRECT, false, false));
						activeCard1.queueFlipDown();
						activeCard2.queueFlipDown();
					}
				}
			}
		}
		
		private function gameFinished():void {
			timer.stop();
			dispatchEvent(new MemoryGameEvent(MemoryGameEvent.FINISH, false, false));
		}
		
		private function onTimeout(e:TimerEvent):void {
			dispatchEvent(new MemoryGameEvent( MemoryGameEvent.TIMEOUT, false, false));
			timer.stop();
			timer.reset();
		}
		
		public function pause():void {
			if (_isPlaying) {
				timer.stop();
			}
		}
		
		public function get totalMatched():int {
			return _totalMatched;
		}
		
		public function get timeRemainning():Number {
			return _timeRemainning;
		}
		
		public function get totalMatchs():int {
			return _totalMatchs;
		}
		
		public function get timeLimit():int {
			return _timeLimit;
		}
		
		public function get flipUpCallback():Function {
			return _flipUpCallback;
		}
		
		public function set flipUpCallback(value:Function):void {
			_flipUpCallback = value;
		}
		
		public function get flipDownCallback():Function {
			return _flipDownCallback;
		}
		
		public function set flipDownCallback(value:Function):void {
			_flipDownCallback = value;
		}
		
		public function get matchCallback():Function {
			return _matchCallback;
		}
		
		public function set matchCallback(value:Function):void {
			_matchCallback = value;
		}
	}

}