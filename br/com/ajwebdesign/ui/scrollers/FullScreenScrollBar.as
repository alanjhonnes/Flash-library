package br.com.ajwebdesign.ui.scrollers {
	import flash.display.*
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import com.greensock.OverwriteManager;
	import com.greensock.TweenMax;
	import temple.core.CoreSprite;
	
	public class FullScreenScrollBar extends CoreSprite
	{
		private var _content:DisplayObjectContainer;
		private var _trackColor:uint;
		private var _grabberColor:uint;
		private var _grabberPressColor:uint;
		private var _gripColor:uint;
		private var _trackThickness:int;
		private var _grabberThickness:int;
		private var _easeAmount:int;
		private var _hasShine:Boolean;
		
		private var _track:Sprite;
		private var _grabber:Sprite;
		private var _grabberGrip:Sprite;
		private var _grabberArrow1:Sprite;
		private var _grabberArrow2:Sprite;
		
		private var _tH:Number; // Track height
		private var _cH:Number; // Content height
		private var _scrollValue:Number;
		private var _defaultPosition:Number;
		private var _stage:Stage;
		private var _stageW:Number;
		private var _stageH:Number;
		private var _pressed:Boolean = false;
		private var _topPadding:int;
		private var _bottomPadding:int;
		
		 /**
		 * Creates a new Fullscreen scrollbar instance
		 * @param container [DisplayObjectContainer] - scrolling container		 		 
		 * @param trackColor [uint] - track color of  the scrollbar
		 * @param grabberColor [uint] -  grabber color of  the scrollbar 
		 * @param grabberPressColor [uint - grabber press color of  the scrollbar 
		 * @param gripColor [uint] - grip color of  the scrollbar
		 * @param trackThickness [int] - track thickness of  the scrollbar
		 * @param grabberThickness [int] - grabber thickness of  the scrollbar
		 * @param easeAmount [int] - ease amount when scrolling
		 * @param hasShine [Boolean] - "has shine" - graphic decors of the scrollbar
		 * @param topPadding [uint=0] - top padding of the scrollbar, useful when you have a header of the site and want the scrollbar top position below the header.
		 * 
		 */
		
		//============================================================================================================================
		public function FullScreenScrollBar(container:DisplayObjectContainer, trackColor:uint, grabberColor:uint, grabberPressColor:uint, gripColor:uint, trackThickness:int, grabberThickness:int, easeAmount:int, hasShine:Boolean, topPadding:int=0, bottomPadding:int = 0)
		//============================================================================================================================
		{
			_content = container;
			_trackColor = trackColor;
			_trackColor = trackColor;
			_grabberColor = grabberColor;
			_grabberPressColor = grabberPressColor;
			_gripColor = gripColor;
			_trackThickness = trackThickness;
			_grabberThickness = grabberThickness;
			_easeAmount = easeAmount;
			_hasShine = hasShine;
			
			//_hPadding - vertikal padding for headers in layout
			_topPadding = topPadding;
			_bottomPadding = bottomPadding;
			this.y = _topPadding;
			init();
			OverwriteManager.init();
		}
		
		//============================================================================================================================
		private function init():void
		//============================================================================================================================
		{
			createTrack();
			createGrabber();
			createGrips();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			_defaultPosition = Math.round(_content.y);
			_grabber.y = 0;
		}
		
		//============================================================================================================================
		public function kill():void
		//============================================================================================================================
		{
			_stage.removeEventListener(Event.RESIZE, onStageResize);
			_grabber.removeEventListener(Event.ENTER_FRAME, scrollContent);
			_stage.removeEventListener(Event.MOUSE_LEAVE, stopScroll);
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener);
			_stage.removeEventListener(Event.RESIZE, onStageResize);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onUpListener);
			_grabber.removeEventListener(MouseEvent.MOUSE_DOWN, onDownListener);
			_track.addEventListener(MouseEvent.CLICK, onTrackClick);
			destruct();
		}
		
		//============================================================================================================================
		private function stopScroll(e:Event):void
		//============================================================================================================================
		{
			onUpListener();
		}
		
		//============================================================================================================================
		private function scrollContent(e:Event=null):void
		//============================================================================================================================
		{
			var ty:Number;
			var dist:Number;
			var moveAmount:Number;
			
			//ty = -((_cH- _topPadding - _tH) * (_grabber.y / _scrollValue));
			ty = -((_cH- _topPadding - _tH) * (_grabber.y / _scrollValue));
			dist = ty - _content.y + _defaultPosition;
			moveAmount = dist / _easeAmount;
			_content.y += Math.round(moveAmount);
			
			if (Math.abs(_content.y - ty - _defaultPosition) < 1.5)
			{
				_grabber.removeEventListener(Event.ENTER_FRAME, scrollContent);
				_content.y = Math.round(ty) + _defaultPosition;
			}
			
			positionGrips();
		}
		
		//============================================================================================================================
		public function adjustSize():void
		//============================================================================================================================
		{
			this.x = _stageW - _trackThickness;
			_track.height = _stageH;
			_track.y = 0;
			_tH = _track.height;
			_cH = _content.height + _defaultPosition;
			
			// Set height of grabber relative to how much content
			_grabber.getChildByName("bg").height = Math.ceil((_tH / _cH) * _tH);
			
			// Set minimum size for grabber
			if(_grabber.getChildByName("bg").height < 35) _grabber.getChildByName("bg").height = 35;
			if(_hasShine) _grabber.getChildByName("shine").height = _grabber.getChildByName("bg").height;
			
			// If scroller is taller than stage height, set its y position to the very bottom
			if ((_grabber.y + _grabber.getChildByName("bg").height) > _tH) _grabber.y = _tH - _grabber.getChildByName("bg").height;
			
			// If content height is less than stage height, set the scroller y position to 0, otherwise keep it the same
			_grabber.y = (_cH < _tH) ? 0 : _grabber.y;
			
			// If content height is greater than the stage height, show it, otherwise hide it
			//this.visible = (_cH + 8 > _tH);
			this.visible = (_cH > _tH);		
			
			
			// Distance left to scroll
			_scrollValue = _tH - _grabber.getChildByName("bg").height;
			
			_content.y = Math.round(-((_cH - _tH) * (_grabber.y / _scrollValue)) + _defaultPosition);
			
			positionGrips();
			
			if(_content.height < stage.stageHeight-_topPadding - _bottomPadding) { stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener); } else { stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener); }
		}
		
		//============================================================================================================================
		private function positionGrips():void
		//============================================================================================================================
		{
			_grabberGrip.y = Math.ceil(_grabber.getChildByName("bg").y + (_grabber.getChildByName("bg").height / 2) - (_grabberGrip.height / 2));
			_grabberArrow1.y = _grabber.getChildByName("bg").y + 8;
			_grabberArrow2.y = _grabber.getChildByName("bg").height - 8;
		}
		
		
		
		
		//============================================================================================================================
		
		
		// CREATORS
		
		
		//============================================================================================================================
		
		//============================================================================================================================
		private function createTrack():void
		//============================================================================================================================
		{
			_track = new Sprite();
			var t:Sprite = new Sprite();
			t.graphics.beginFill(_trackColor); 
			t.graphics.drawRect(0, 0, _trackThickness, _trackThickness);
			t.graphics.endFill();
			_track.addChild(t);
			addChild(_track);
		}
		
		//============================================================================================================================
		private function createGrabber():void
		//============================================================================================================================
		{
			_grabber = new Sprite();
			var t:Sprite = new Sprite();
			t.graphics.beginFill(_grabberColor); 
			t.graphics.drawRect(0, 0, _grabberThickness, _grabberThickness);
			t.graphics.endFill();
			t.name = "bg";
			_grabber.addChild(t);
			
			if(_hasShine)
			{
				var shine:Sprite = new Sprite();
				var sg:Graphics = shine.graphics;
				sg.beginFill(0xffffff, 0.15);
				sg.drawRect(0, 0, Math.ceil(_trackThickness / 2), _trackThickness);
				sg.endFill();
				shine.x = Math.floor(_trackThickness/2);
				shine.name = "shine";
				_grabber.addChild(shine);
			}
			
			addChild(_grabber);
		}
		
		//============================================================================================================================
		private function createGrips():void
		//============================================================================================================================
		{
			_grabberGrip = createGrabberGrip();
			_grabber.addChild(_grabberGrip);
			
			_grabberArrow1 = createPixelArrow();
			_grabber.addChild(_grabberArrow1);
			
			_grabberArrow2 = createPixelArrow();
			_grabber.addChild(_grabberArrow2);
			
			_grabberArrow1.rotation = -90;
			_grabberArrow1.x = ((_grabberThickness - 7) / 2) + 1;
			_grabberArrow2.rotation = 90;
			_grabberArrow2.x = ((_grabberThickness - 7) / 2) + 6;
		}
		
		//============================================================================================================================
		private function createGrabberGrip():Sprite
		//============================================================================================================================
		{
			var w:int = 7;
			var xp:int = (_grabberThickness - w) / 2;
			var t:Sprite = new Sprite();
			//t.graphics.beginFill(_gripColor, 1);
			t.graphics.beginFill(_gripColor, 0.5);
			t.graphics.drawRect(xp, 0, w, 1);
			t.graphics.drawRect(xp, 0 + 2, w, 1);
			t.graphics.drawRect(xp, 0 + 4, w, 1);
			t.graphics.drawRect(xp, 0 + 6, w, 1);
			t.graphics.drawRect(xp, 0 + 8, w, 1);
			t.graphics.endFill();
			return t;
		}
		
		//============================================================================================================================
		private function createPixelArrow():Sprite
		//============================================================================================================================
		{
			var t:Sprite = new Sprite();			
			//t.graphics.beginFill(_gripColor, 1);
			t.graphics.beginFill(_gripColor, 0.5);
			t.graphics.drawRect(0, 0, 1, 1);
			t.graphics.drawRect(1, 1, 1, 1);
			t.graphics.drawRect(2, 2, 1, 1);
			t.graphics.drawRect(1, 3, 1, 1);
			t.graphics.drawRect(0, 4, 1, 1);
			t.graphics.endFill();
			return t;
		}
		
		
		
		
		//============================================================================================================================
		
		
		// LISTENERS
		
		
		//============================================================================================================================
		
		//============================================================================================================================
		private function mouseWheelListener(me:MouseEvent):void
		//============================================================================================================================
		{
			var d:Number = me.delta;
			if (d > 0)
			{
				if ((_grabber.y - (d * 4)) >= 0)
				{
					_grabber.y -= d * 4;
				}
				else
				{
					_grabber.y = 0;
				}
				
				if (!_grabber.willTrigger(Event.ENTER_FRAME)) _grabber.addEventListener(Event.ENTER_FRAME, scrollContent);
			}
			else
			{
				if (((_grabber.y + _grabber.height) + (Math.abs(d) * 4)) <= stage.stageHeight-_topPadding - _bottomPadding)
				{
					_grabber.y += Math.abs(d) * 4;
				}
				else
				{
					_grabber.y = stage.stageHeight-_topPadding - _bottomPadding - _grabber.height;
				}
				if (!_grabber.willTrigger(Event.ENTER_FRAME)) _grabber.addEventListener(Event.ENTER_FRAME, scrollContent);
			}
		}
		
		//============================================================================================================================
		private function onDownListener(e:MouseEvent):void
		//============================================================================================================================
		{
			_pressed = true;
			_grabber.startDrag(false, new Rectangle(0, 0, 0, _stageH - _grabber.getChildByName("bg").height));
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveListener, false, 0, true);
			TweenMax.to(_grabber.getChildByName("bg"), 0.5, { tint:_grabberPressColor } );
		}
		
		//============================================================================================================================
		private function onUpListener(e:MouseEvent = null):void
		//============================================================================================================================
		{
			if (_pressed)
			{
				_pressed = false;
				_grabber.stopDrag();
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveListener);
				TweenMax.to(_grabber.getChildByName("bg"), 0.5, { tint:null } );
			}
		}
		
		//============================================================================================================================
		private function onMouseMoveListener(e:MouseEvent):void
		//============================================================================================================================
		{
			e.updateAfterEvent();
			if (!_grabber.willTrigger(Event.ENTER_FRAME)) _grabber.addEventListener(Event.ENTER_FRAME, scrollContent, false, 0, true);
		}
		
		//============================================================================================================================
		private function onTrackClick(e:MouseEvent):void
		//============================================================================================================================
		{
			_grabber.addEventListener(Event.ENTER_FRAME, scrollContent, false, 0, true);
			var p:int;
			var s:int = 150;
			
			p = Math.ceil(e.stageY);
			if(p < _grabber.y)
			{
				if(_grabber.y < _grabber.height)
				{
					TweenMax.to(_grabber, 0.5, {y:0, onComplete:reset, overwrite:1});
				}
				else
				{
					TweenMax.to(_grabber, 0.5, {y:"-150", onComplete:reset});
				}
				
				if(_grabber.y < 0) _grabber.y = 0;
			}
			else
			{
				if((_grabber.y + _grabber.height) > (_stageH - _grabber.height))
				{
					TweenMax.to(_grabber, 0.5, {y:_stageH - _grabber.height, onComplete:reset, overwrite:1});
				}
				else
				{
					TweenMax.to(_grabber, 0.5, {y:"150", onComplete:reset});
				}
				
				if (_grabber.y + _grabber.getChildByName("bg").height > _track.height) _grabber.y = stage.stageHeight - _topPadding - _grabber.getChildByName("bg").height;
			}
			
			function reset():void
			{
				if(_grabber.y < 0) _grabber.y = 0;
				if(_grabber.y + _grabber.getChildByName("bg").height > _track.height) _grabber.y = stage.stageHeight-_topPadding - _bottomPadding - _grabber.getChildByName("bg").height;
			}
		}
		
		//============================================================================================================================
		private function onAddedToStage(e:Event):void
		//============================================================================================================================
		{
			_stage = stage;
			_stage.addEventListener(Event.MOUSE_LEAVE, stopScroll);
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener);
			_stage.addEventListener(Event.RESIZE, onStageResize, false, 0, false);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onUpListener, false, 0, false);
			_grabber.addEventListener(MouseEvent.MOUSE_DOWN, onDownListener, false, 0, false);
			_grabber.buttonMode = true;
			_track.addEventListener(MouseEvent.CLICK, onTrackClick, false, 0, false);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_stageW = _stage.stageWidth;
			_stageH = _stage.stageHeight-_topPadding - _bottomPadding;
			adjustSize();
		}
		
		//============================================================================================================================
		private function onStageResize(e:Event):void
		//============================================================================================================================
		{			
			_stageW = _stage.stageWidth;
			_stageH = _stage.stageHeight-_topPadding - _bottomPadding;
			adjustSize();
		}
		
		//LOTE-CHANGE CONTENT
		public function set content( value:DisplayObjectContainer ):void 
		{
			_content = value;
		}
		
		//Go to top immediatly without animation
		public function goToTop() {
			_grabber.y	= 0;
			adjustSize();			
		}
		//Go to down immediatly without animation
		public function goToDown() {
			_grabber.y	= _track.height - _grabber.getChildByName("bg").height;
			adjustSize();			
		}		
		
		//Goto specfic y without animation
		public function goTo(yPos:Number) {
			if (yPos > _track.height - _grabber.getChildByName("bg").height) {
				goToDown();
			}else if(yPos < 0) {
				goToTop();
			}else {
				_grabber.y = yPos;
				adjustSize();			
				
			}			
		}
		//Go to top with animation
		public function scrollToTop() {
			if(this.visible){
				_grabber.y	= 0;			
				if (!_grabber.willTrigger(Event.ENTER_FRAME)) _grabber.addEventListener(Event.ENTER_FRAME, scrollContent);
			}
			
		}	
		//Go to down with animation
		public function scrollToDown() {
			if(this.visible){
				_grabber.y	= _track.height - _grabber.getChildByName("bg").height;
				if (!_grabber.willTrigger(Event.ENTER_FRAME)) _grabber.addEventListener(Event.ENTER_FRAME, scrollContent);
			}
			
		}
		//Goto specific y with animation. Usefull to implement for like "html anchor" functionallity
		public function scrollTo(yPos:Number) {			
			if(this.visible){
				if (yPos > _track.height - _grabber.getChildByName("bg").height) {
					scrollToDown();
				}else if(yPos < 0) {
					scrollToTop();
				}else {
					_grabber.y = yPos;
					if (!_grabber.willTrigger(Event.ENTER_FRAME)) _grabber.addEventListener(Event.ENTER_FRAME, scrollContent);
					
				}
			}
		}
		//Move scrollbar by with animation
		public function scrollBy(yFactor:Number) {			
			scrollTo(_grabber.y + yFactor);
		}		
		
		//scrolPageDown with animation
		public function scrolPageDown() {			
			scrollTo(_grabber.y + _grabber.height);
		}		
		//scrolPageUp with animation
		public function scrolPageUp() {			
			scrollTo(_grabber.y - _grabber.height);
		}
	}
}