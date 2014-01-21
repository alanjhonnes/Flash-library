package br.com.ajwebdesign.games.wordhunt {
	
	import br.com.ajwebdesign.games.wordhunt.WordHuntEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import hype.extended.layout.GridLayout;
	import temple.core.CoreSprite;
	import temple.utils.types.ArrayUtils;
	import temple.utils.types.VectorUtils;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	[Event(name="change", type="flash.events.Event")]
	[Event(name="selectionEnded", type="br.com.ajwebdesign.games.wordhunt.WordHuntEvent")]
	[Event(name="selectionStart", type="br.com.ajwebdesign.games.wordhunt.WordHuntEvent")]
	public class WordHunt extends CoreSprite {
		//Positions cache
		private var topLeft:int = 0;
		private var topRight:int;
		private var bottomLeft:int;
		private var bottomRight:int;
		private var top:Vector.<int>;
		private var left:Vector.<int>;
		private var right:Vector.<int>;
		private var bottom:Vector.<int>;
		
		private var _columns:int;
		private var _rows:int;
		private var _charMap:Vector.<String>;
		private var _chars:Vector.<Character>;
		private var _matches:Vector.<String>;
		private var _matchLocations:Vector.<Array>;
		private var grid:GridLayout;
		
		private var availableSelections:Vector.<Character> = new Vector.<Character>();
		private var selectedChars:Vector.<Character> = new Vector.<Character>();
		
		private var _startChar:Character;
		private var currentDirection:int;
		
		override public function destruct():void {
			super.destruct();
			
		}
		
		
		public function WordHunt(charMap:Vector.<String>, matches:Vector.<Array>, columns:int, spacing:Number = 30) {
			_columns = columns;
			grid = new GridLayout(0, 0, spacing, spacing, _columns);
			_charMap = charMap;
			_matchLocations = matches;
			var i:int = 0;
			var totalChars:int = _charMap.length;
			_rows = totalChars / columns; 
			//calculate positions cache
			cachePositions();
			//populate grid
			_chars = new Vector.<Character>();
			var char:Character;
			for ( i = 0; i < totalChars; i++) {
				char = new Character(_charMap[i], i, this, calculateLocation(i) );
				char.addEventListener(WordHuntEvent.SELECTION_START, onSelectionStart);
				//char.addEventListener(WordHuntEvent.SELECTION_END, onSelectionEnd);
				grid.applyLayout(char);
				_chars.push(char);
				addChild(char);
			}
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//addEventListener(MouseEvent.ROLL_OUT, onSelectionEnd);
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(MouseEvent.MOUSE_UP, onSelectionEnd);
		}
		
		private function calculateLocation(id:int):int {
			switch (id) {
				case topLeft: 
					return Character.TOP_LEFT;
				case topRight:
					return Character.TOP_RIGHT;
				case bottomLeft:
					return Character.BOTTOM_LEFT;
				case bottomRight: 
					return Character.BOTTOM_RIGHT;
				default: {
					if (id > topLeft && id < topRight) {
						return Character.TOP;
					}
					if (id % _columns == 0) {
						return Character.LEFT;
					}
					if (((id +1) % _columns) == 0) {
						return Character.RIGHT;
					}
					if (id > bottomLeft && id < bottomRight) {
						return Character.BOTTOM;
					}
					return Character.MIDDLE;
				}
			}
		}
		
		private function cachePositions():void {
			var i:int = 1;
			topRight = _columns -1;
			bottomLeft = _columns * (_rows -1);
			bottomRight = _columns * _rows -1;
			var j:int = topRight;
			top = new Vector.<int>();
			for ( i; i < j; i++) {
				top.push(i);
			}
			
			left = new Vector.<int>();
			i = _columns;
			for ( i; i < bottomLeft; i = i + _columns) {
				left.push(i);
			}
			
			right = new Vector.<int>();
			i = topRight;
			for ( i; i < bottomRight; i = i + _columns) {
				right.push(i);
			}
			
			bottom = new Vector.<int>();
			i = bottomLeft;
			for (i; i < bottomRight; i++ ) {
				bottom.push(i);
			}
		}
		
		private function onSelectionStart(e:WordHuntEvent):void {
			trace("Selection start");
			availableSelections = new Vector.<Character>();
			var startId:int = e.id;
			selectedChars = new Vector.<Character>();
			selectedChars.push(_chars[e.id]);
			_startChar = _chars[e.id];
			_startChar.setSelected();
			//_startChar.addEventListener(MouseEvent.ROLL_OVER, onStartOver);
			//_startChar.setSelected();
			availableSelections = getAllPossibleSelections(startId);
			for each(var char:Character in availableSelections) {
				//char.addEventListener(MouseEvent.ROLL_OVER, onSecondSelection);
				char.addEventListener(MouseEvent.ROLL_OVER, onIntervalSelected);
				char.setSelectable();
			}
			dispatchEvent(new WordHuntEvent(WordHuntEvent.SELECTION_START));
		}
		
		private function onIntervalSelected(e:MouseEvent):void {
			var i:int;
			var j:int = selectedChars.length;
			var char:Character;
			for (i = 1; i < j; i++) {
				char = selectedChars[i];
				char.setSelectable();
			}
			selectedChars = new Vector.<Character>();
			selectedChars.push(_startChar);
			
			var startId:int = _startChar.id;
			var lastChar:Character = e.currentTarget as Character;
			var directions:Vector.<int> = _startChar.availableDirections;
			j = directions.length;
			var direction:int;
			var charsToTest:Vector.<Character>;
			var k:int;
			var l:int;
			var found:Boolean;
			//find the direction of the interval
			
			for (i = 0; i < j; i++) {
				direction = directions[i];
				charsToTest = getCharsOnDirection(direction, startId);
				l = charsToTest.length;
				for (k = 0; k < l; k++) {
					if ( charsToTest[k] == lastChar) {
						found = true;
						break;
					}
				}
				if(found) {
					break;
				}
			}
			for (i = 0; i <= k; i++) {
				char = charsToTest[i];
				char.setSelected();
				selectedChars.push(char);
			}
		}
		
		private function onSelectionEnd(e:MouseEvent):void {
			trace("Selection End");
			var i:int = 0;
			var j:int;
			var k:int;
			var l:int;
			var found:Boolean;
			j = selectedChars.length;
			var selectedIds:Array = [];
			for (i = 0; i < j; i++) {
				selectedIds.push(selectedChars[i].id);
			}
			selectedIds.sort(Array.NUMERIC);
			trace(selectedIds);
			j = _matchLocations.length;
			trace("Remainning words: " + j);
			for (i = 0; i < j; i++) {
				if (ArrayUtils.areEqual(selectedIds, _matchLocations[i])) {
					l = selectedChars.length;
					for ( k = 0; k < l; k++) {
						selectedChars[i].setActive();
					}
					//removes the word from the matches
					_matchLocations[i] = [];
					dispatchEvent(new WordHuntEvent(WordHuntEvent.WORD_FOUND, i));
					trace("word found");
					found = true;
					break;
				}
			}
			j = availableSelections.length;
			var char:Character;
			
			for (i = 0; i < j; i++) {
				char = availableSelections[i];
				char.setIdle();
				char.removeEventListener(MouseEvent.ROLL_OVER, onIntervalSelected);
			}
			j = selectedChars.length;
			if (found) {
				for (i = 0; i < j; i++) {
					char = selectedChars[i];
					char.setActive();
				}
			}
			else {
				_startChar.setIdle();
				for (i = 0; i < j; i++) {
					char = selectedChars[i];
				}
				j = availableSelections.length;
				for (i = 0; i < j; i++) {
					char = availableSelections[i];
					char.setIdle();
					char.removeEventListener(MouseEvent.ROLL_OVER, onIntervalSelected);
				}
				availableSelections = new Vector.<Character>();
			}
			dispatchEvent(new WordHuntEvent(WordHuntEvent.SELECTION_END));
		}
		
		private function onStartOver(e:MouseEvent):void {
			availableSelections = new Vector.<Character>();
			var possibleSelections:Vector.<Character> = getPossibleCharSelections(_startChar.id);
			for each(var char:Character in possibleSelections) {
				char.setSelectable();
				availableSelections.push(char);
			}
			dispatchEvent(new WordHuntEvent(Event.CHANGE));
		}
		
		public function getPossibleSelections(id:int):Vector.<int> {
			var selections:Vector.<int> = new Vector.<int>();
			return selections;
		}
		
		public function getPossibleCharSelections(id:int, limitDirection:Boolean = false, direction:int = 0):Vector.<Character> {
			var selections:Vector.<Character> = new Vector.<Character>();
			var char:Character = _chars[id];
			var location:int = char.location;
			switch (location) {
				case Character.MIDDLE: {
					selections.push(_chars[id - 1 - _columns]);
					selections.push(_chars[id - _columns]);
					selections.push(_chars[id +1 - _columns]);
					selections.push(_chars[id - 1]);
					selections.push(_chars[id + 1]);
					selections.push(_chars[id - 1 + _columns]);
					selections.push(_chars[id + _columns]);
					selections.push(_chars[id + 1 + _columns]);
					break;
				}
				case Character.TOP: {
					selections.push(_chars[id - 1]);
					selections.push(_chars[id + 1]);
					selections.push(_chars[id - 1 + _columns]);
					selections.push(_chars[id + _columns]);
					selections.push(_chars[id + 1 + _columns]);
					break;
				}
				case Character.RIGHT: {
					selections.push(_chars[id - 1 - _columns]);
					selections.push(_chars[id - _columns]);
					selections.push(_chars[id - 1]);
					selections.push(_chars[id - 1 + _columns]);
					selections.push(_chars[id + _columns]);
					break;
				}
				case Character.BOTTOM: {
					selections.push(_chars[id - 1 - _columns]);
					selections.push(_chars[id - _columns]);
					selections.push(_chars[id +1 - _columns]);
					selections.push(_chars[id - 1]);
					selections.push(_chars[id + 1]);
					break;
				}
				case Character.LEFT: {
					selections.push(_chars[id - _columns]);
					selections.push(_chars[id +1 - _columns]);
					selections.push(_chars[id + 1]);
					selections.push(_chars[id + _columns]);
					selections.push(_chars[id + 1 + _columns]);
				}
				case Character.TOP_LEFT: {
					selections.push(_chars[id + 1]);
					selections.push(_chars[id + _columns]);
					selections.push(_chars[id + 1 + _columns]);
					break;
				}
				case Character.TOP_RIGHT: {
					selections.push(_chars[id - 1]);
					selections.push(_chars[id - 1 + _columns]);
					selections.push(_chars[id + _columns]);
					break;
				}
				case Character.BOTTOM_LEFT: {
					selections.push(_chars[id - _columns]);
					selections.push(_chars[id +1 - _columns]);
					selections.push(_chars[id + 1]);
					break;
				}
				case Character.BOTTOM_RIGHT: {
					selections.push(_chars[id -1 - _columns]);
					selections.push(_chars[id - _columns]);
					selections.push(_chars[id - 1]);
					break;
				}
			}
			return selections;
		}
		
		
		public function getCharOnDirection(direction:int, id:int):Character {
			
			var directions:Vector.<int> = _chars[id].availableDirections;
			var i:int = 0;
			var j:int = directions.length;
			var valid:Boolean;
			for (i; i < j; i++) {
				if (direction == directions[i]) {
					valid = true;
					break;
				}
			}
			if (valid) {
				switch (direction) {
					case Directions.LEFT: {
						return _chars[id - 1]; 
						break;
					}
					case Directions.UP_LEFT: {
						return _chars[id - 1 - _columns]; 
						break;
					}
					case Directions.UP: {
						return _chars[id - _columns]; 
						break;
					}
					case Directions.UP_RIGHT: {
						return _chars[id + 1 - _columns]; 
						break;
					}
					case Directions.RIGHT: {
						return _chars[id + 1]; 
						break;
					}
					case Directions.DOWN_RIGHT: {
						return _chars[id + 1 + _columns]; 
						break;
					}
					case Directions.DOWN: {
						return _chars[id + _columns]; 
						break;
					}
					case Directions.DOWN_LEFT: {
						return _chars[id - 1 + _columns]; 
						break;
					}
				}
			}
			return null;
		}
		
		//Recursively gets all the characters in a direction
		public function getCharsOnDirection(direction:int, id:int):Vector.<Character> {
			var charsOnDirection:Vector.<Character> = new Vector.<Character>();
			var i:int = 0;
			var j:int;
			var char:Character;
			var limit:int;
			if (_columns > _rows) {
				limit = _columns;
			}
			else {
				limit = _rows;
			}
			for (i; i < limit; i++) {
				char = getCharOnDirection(direction, id);
				if (char) {
					id = char.id;
					charsOnDirection.push(char);
				}
				else {
					break;
				}
			}

			return charsOnDirection;
		}
		
		//gets all chars in all directions available for selection
		public function getAllPossibleSelections(id:int):Vector.<Character> {
			var startId:int = id;
			var allChars:Vector.<Character> = new Vector.<Character>();
			var i:int = 0;
			var j:int;
			var char:Character;
			var limit:int;
			var directions:Vector.<int> = _chars[id].availableDirections;
			var k:int;
			var l:int = directions.length;
			if (_columns > _rows) {
				limit = _columns;
			}
			else {
				limit = _rows;
			}
			for (k; k < l; k++) {
				for (i = 0; i < limit; i++) {
					char = getCharOnDirection(directions[k], id);
					if (char) {
						id = char.id;
						allChars.push(char);
					}
					else {
						break;
					}
				}
				id = startId;
			}
			return allChars;
		}
		
		public function get rows():int {
			return _rows;
		}
		
		public function get columns():int {
			return _columns;
		}
		
		public function get chars():Vector.<Character> {
			return _chars;
		}
		
	}

}