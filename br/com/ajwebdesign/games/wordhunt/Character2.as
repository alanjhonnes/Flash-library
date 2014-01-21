package br.com.ajwebdesign.games.wordhunt {
	
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import temple.core.CoreMovieClip;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	[Event(name="selectionStart", type="br.com.ajwebdesign.games.wordhunt.WordHuntEvent")]
	public class Character extends CoreMovieClip {
		
		public static const TOP_LEFT:int = 0;
		public static const TOP:int = 1;
		public static const TOP_RIGHT:int = 2;
		public static const LEFT:int = 3;
		public static const MIDDLE:int = 4;
		public static const RIGHT:int = 5;
		public static const BOTTOM_LEFT:int = 6;
		public static const BOTTOM:int = 7;
		public static const BOTTOM_RIGHT:int = 8;
		
		public static const IDLE:String = "idle";
		public static const SELECTABLE:String = "selectable";
		public static const SELECTED:String = "selected";
		public static const MATCHED:String = "matched";
		public static const OVER:String = "over";
		
		public var txt:TextField// = new TextField();
		public var background:Sprite = new Sprite();
		
		
		private var active:Boolean;
		private var _selected:Boolean;
		
		private var _state:String = "idle";
		
		
		private var _game:WordHunt;
		private var _location:int;
		private var _selections:Vector.<int>;
		private var _id:int;
		private var _text:String;
		
		private var topLeftId:int = -1;
		private var topId:int = -1;
		private var topRightId:int = -1;
		private var leftId:int = -1;
		private var rightId:int = -1;
		private var bottomLeftId:int = -1;
		private var bottomId:int = -1;
		private var bottomRightId:int = -1;
		
		private var _selectable:Boolean;
		
		private var _availableDirections:Vector.<int>;
		private var _selecting:Boolean;
		
		override public function destruct():void {
			removeEventListener(MouseEvent.ROLL_OVER, onOver);
			removeEventListener(MouseEvent.ROLL_OUT, onOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_game = null;
			txt = null;
			background = null;
			super.destruct();
		}
		
		private function onMouseUp(e:MouseEvent):void {
			dispatchEvent(new WordHuntEvent( WordHuntEvent.SELECTION_END, _id, null, 0, location));
		}
		
		public function Character(char:String, id:int, game:WordHunt, location:int = 0) {
			_text = char;
			_id = id;
			//_selections = selections;
			_location = location;
			_game = game;
			switch (_location) {
				case Character.MIDDLE: {
					_availableDirections = new <int>[Directions.UP, Directions.UP_RIGHT, Directions.RIGHT, Directions.DOWN_RIGHT, Directions.DOWN, Directions.DOWN_LEFT, Directions.LEFT, Directions.UP_LEFT];
					break;
				}
				case Character.LEFT: {
					_availableDirections = new <int>[Directions.UP, Directions.UP_RIGHT, Directions.RIGHT, Directions.DOWN_RIGHT, Directions.DOWN];
					break;
				}
				case Character.RIGHT: {
					_availableDirections = new <int>[Directions.LEFT, Directions.UP_LEFT, Directions.UP, Directions.DOWN, Directions.DOWN_LEFT];
					break;
				}
				case Character.TOP: {
					_availableDirections = new <int>[Directions.LEFT, Directions.RIGHT, Directions.DOWN_RIGHT, Directions.DOWN, Directions.DOWN_LEFT];
					break;
				}
				case Character.BOTTOM: {
					_availableDirections = new <int>[Directions.UP, Directions.UP_RIGHT, Directions.UP_LEFT, Directions.LEFT, Directions.RIGHT];
					break;
				}
				case Character.TOP_LEFT: {
					_availableDirections = new <int>[Directions.RIGHT, Directions.DOWN_RIGHT, Directions.DOWN];
					break;
				}
				
				case Character.TOP_RIGHT: {
					_availableDirections = new <int>[Directions.LEFT, Directions.DOWN, Directions.DOWN_LEFT];
					break;
				}
				
				case Character.BOTTOM_RIGHT: {
					_availableDirections = new <int>[Directions.LEFT, Directions.UP_LEFT, Directions.UP];
					break;
				}
				case Character.BOTTOM_LEFT: {
					_availableDirections = new <int>[Directions.UP, Directions.UP_RIGHT, Directions.RIGHT];
					break;
				}
			}
			txt.text = _text;
			
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_game.addEventListener(WordHuntEvent.SELECTION_START, onSelectionStart);
			_game.addEventListener(WordHuntEvent.SELECTION_START, onSelectionEnd);
			buttonMode = true;
			txt.mouseEnabled = false;
			
			/*
			txt.textColor = 0x003c69;
			txt.width = 30;
			txt.y = 6;
			txt.autoSize = TextFieldAutoSize.CENTER;
			background.graphics.beginFill(0xAAAAAA);
			background.graphics.drawRect(0, 0, 30, 30);
			background.graphics.endFill();
			addChild(background);
			addChild(txt);
			*/
		}
		
		
		
		private function onSelectionStart(e:WordHuntEvent):void {
			_selecting = true;
		}
		
		private function onSelectionEnd(e:WordHuntEvent):void {
			_selecting = false;
		}
		
		private function onMouseDown(e:MouseEvent):void {
			dispatchEvent(new WordHuntEvent( WordHuntEvent.SELECTION_START, _id, null, 0, _location, false, false ));
		}
		
		public function get id():int {
			return _id;
		}
		
		public function get location():int {
			return _location;
		}
		
		public function get text():String {
			return _text;
		}
		
		public function get availableDirections():Vector.<int> {
			return _availableDirections;
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		public function set selected(value:Boolean):void {
			_selected = value;
		}
		
		public function setIdle():void {
			if (active) {
				TweenMax.to( this, 0.4, { frameLabel:"active", overwrite:3 } );
			}
			else {
				if (_selectable || _selected) {
				TweenMax.to( this, 0.4, { frameLabel:"idle", overwrite:3 } );
				}
			}
			selected = false;
			_selectable = false;
		}
		
		public function setSelected():void {
			selected = true;
			TweenMax.to( this, 0.4, { frameLabel:"selected", overwrite:3 } );
		}
		
		public function setSelectable():void {
			_selected = false;
			_selectable = true;
			if ( !active) {
				TweenMax.to( this, 0.4, { frameLabel:"selectable", overwrite:3 } );
			}
			else {
				gotoAndPlay("activeToSelectable");
			}
			
		}
		
		public function setActive():void {
			active = true;
			TweenMax.to( this, 0.4, { frameLabel:"active", overwrite:3 } );
			//TweenMax.to( background, 0.4, { tint:0x000000 } );
		}
		
		private function onOut(e:MouseEvent):void {
			if (!active && !selected) {
				TweenMax.to( this, 0.4, { frameLabel:"idle", overwrite:3 } );
			}
			if (_selectable && !selected) {
				TweenMax.to( this, 0.4, { frameLabel:"selectable", overwrite:3 } );
			}
			if (active && !_selectable) {
				TweenMax.to( this, 0.4, { frameLabel:"active", overwrite:3 } );
			}
		}
		
		private function onOver(e:MouseEvent):void {
			if (!_selecting) {
				//TweenMax.to( this, 0.4, { frameLabel:"selectable" } );
			}
		}
		
		
	}

}