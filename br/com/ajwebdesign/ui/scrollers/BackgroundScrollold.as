package br.com.ajwebdesign.ui.scrollers {
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import temple.core.CoreEventDispatcher;
	
	/**
	 * Handles scrolling of big backgrounds on a fluid site.
	 * @author Alan Jhonnes
	 */
	public class BackgroundScroll extends CoreEventDispatcher {
		
		protected var _target:InteractiveObject;
		protected var _scrollType:String;
		protected var _maxSpeed:Number;
		protected var xCenter:Number;
		protected var yCenter:Number;
		protected var stgW:int;
		protected var stgH:int;
		protected var targetW:Number = 0;
		protected var targetH:Number = 0;
		protected var stage:Stage = null;
		protected var percX:Number = 0;
		protected var percY:Number = 0;
		protected var vx:Number = 0;
		protected var vy:Number = 0;
		protected var maxX:int;
		protected var maxY:int;
		//next X position
		protected var targetX:Number;
		//next Y position
		protected var targetY:Number;
		protected var mouseDown:Boolean;
		
		protected var _scrollRadius:Number;
		protected var _rect:Rectangle = new Rectangle(0, 0, 1, 1);
		
		protected var locked:Boolean = false;
		
		protected var _scrollDuration:Number = 0.8;
		
		protected var isTracking:Boolean;
		protected var _trackTarget:DisplayObject;
		protected var _trackPoint:Point = new Point(0, 0);
		protected var _trackOffsetX:Number;
		protected var _trackOffsetY:Number;
		
		public static const ENTER_FRAME:String = "enterFrame";
		public static const MOUSE_DOWN:String = "mouseDown";
		
		protected var _zoom:Boolean;
		protected var minZoom:Number;
		protected var currentZoom:Number = 1;
		
		override public function destruct():void {
			if (_target.hasEventListener(Event.ENTER_FRAME)) {
				_target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			if (_target.hasEventListener(MouseEvent.MOUSE_DOWN)) {
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			if (_target.hasEventListener(MouseEvent.MOUSE_UP)) {
				_target.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			_target = null;
			_trackTarget = null;
			_trackPoint = null;
			stage.removeEventListener(Event.RESIZE, calculateBoundaries);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage = null;
			
			super.destruct();
		}
		
		
		/**
		 * Creates a new BackgroundScroll to handle the scrolling of a target sprite.
		 * @param	target The target to be scrolled, needs to be top-left aligned.
		 * @param	scrollType Type of scroll to use,wheter if its constant or only when the mouse is down. Use the constants of this class.
		 * @param	maxSpeed Max amount of distance to move each frame.
		 * @param radius Radius around the center of the stage in which the background does not move. Value 0 to 1
		 */
		public function BackgroundScroll(target:InteractiveObject, scrollType:String = "enterFrame", maxSpeed:Number = 10,  radius:Number = 0.5, enableZoom:Boolean = false) {
			_target = target;
			targetW = _target.width;
			targetH = _target.height;
			_maxSpeed = maxSpeed;
			_scrollType = scrollType;
			_scrollRadius = radius;
			if (_target.stage) {
				setupStage();
			}
			else {
				_target.addEventListener(Event.ADDED_TO_STAGE, onTargetStage);
			}
			_zoom = enableZoom;
		}
		
		/**
		 * Scrolls and tries to center the position on the stage view. It does not center the position if that'd break the boundaries of the stage.
		 * @param	xPos X position to be centered on stage
		 * @param	yPos Y position to be centered on stage
		 * @param	instantly If the animation is instantly or not
		 * @param	unlockAfterComplete Wheter to unlock further automatic scrolling after moving to desired position
		 */
		public function scrollTo(xPos:Number, yPos:Number, instantly:Boolean = false, unlockAfterComplete:Boolean = false):void {
			lock();
			var percX:Number = xPos / targetW;
			var percY:Number = yPos / targetH;
			targetX = (targetW  * percX) - stgW * 0.5;
			targetY = (targetH  * percY) - stgH * 0.5;
			validatePositions();
			targetX = Math.round(targetX);
			targetY = Math.round(targetY);
			if (!instantly) {
				if (unlockAfterComplete) {
					TweenMax.to(_rect, _scrollDuration, { x:targetX, y:targetY, onUpdate:updateRect, onComplete:unlock } ); 
				}
				else {
					TweenMax.to(_rect, _scrollDuration, { x:targetX, y:targetY, onUpdate:updateRect } ); 
				}
			}
			else {
				_rect.x = targetX;
				_rect.y = targetY;
				_target.scrollRect = _rect;
				unlockAfterComplete ? unlock() : lock();
			}
		}
		
		private function updateRect():void {
			_target.scrollRect = _rect;
		}
		
		/** Centers the target on stage */
		public function centerTarget():void {
			targetX = (targetW  >> 1) - stgW * 0.5;
			targetY = (targetH  >> 1) - stgH * 0.5;
			validatePositions();
			_rect.x = targetX;
			_rect.y = targetY;
			_target.scrollRect = _rect;
		}
		
		/**
		 * Tracks a target object with the camera
		 * @param	trackTarget
		 * @param	trackOffsetX
		 * @param	trackOffsetY
		 */
		public function track(trackTarget:DisplayObject, trackOffsetX:Number = 0, trackOffsetY:Number = 0):void {
			isTracking = true;
			_trackTarget = trackTarget;
			_trackOffsetX = trackOffsetX;
			_trackOffsetY = trackOffsetY;
		}
		
		/**
		 * Stops tracking an object
		 * @param	releaseNavigation Wheter to unlock normal navigation or not.
		 */
		public function stopTrack(releaseNavigation:Boolean = true):void {
			isTracking = false;
			_trackTarget = null;
			_trackOffsetX = 0;
			_trackOffsetY = 0;
			if (releaseNavigation) {
				unlock();
			}
		}
		
		/** Locks normal navigation */
		public function lock():void {
			if (!locked) {
				locked = true;
			}
		}
		
		/** Unlocks the normal navigation */
		public function unlock():void {
			if (locked && !isTracking) {
				locked = false;
			}
		}
		
		private function onTargetStage(e:Event):void {
			_target.removeEventListener(Event.ADDED_TO_STAGE, onTargetStage);
			setupStage();
		}
		
		protected function setupStage():void {
			stage = _target.stage;
			stage.addEventListener(Event.RESIZE, calculateBoundaries);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_target.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_target.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			calculateBoundaries();
		}
		
		protected function onEnterFrame(e:Event):void {
			if (!isTracking && !locked) {
				if (_scrollType == ENTER_FRAME || (_scrollType == MOUSE_DOWN && mouseDown)) {
					scrollTarget();
				}
			}
			else if (isTracking) {
				_trackPoint.x = _trackTarget.x;
				_trackPoint.y = _trackTarget.y;
				scrollTo( _trackPoint.x + _trackOffsetX, _trackPoint.y + _trackOffsetY, false, false);
			}
			
		}
		
		private function onMouseDown(e:MouseEvent):void {
			mouseDown = true;
		}
		
		private function onMouseUp(e:MouseEvent):void {
			mouseDown = false;
		}
		
		
		protected function calculateBoundaries(e:Event = null):void {
			stgW = stage.stageWidth;
			stgH = stage.stageHeight;
			xCenter = stgW >> 1;
			yCenter = stgH >> 1;
			maxX = targetW - stgW;
			maxY = targetH - stgH;
			vx = 0;
			vy = 0;
			_rect.width = stgW;
			_rect.height = stgH;
			if ( _zoom) {
				
			}
			scrollTarget();
		}
		
		protected function onMouseMove(e:MouseEvent):void {
			var distX:Number = xCenter - stage.mouseX;
			var distY:Number = yCenter - stage.mouseY;
			//calculates the distance percentage from the center to the boundaries
			percX = distX / xCenter;
			percY = distY / yCenter;
			
			if (percX < _scrollRadius && percX > 0) {
				percX = 0;
			}
			else if (percX > _scrollRadius) {
				percX -= _scrollRadius;
			}
			if (percX > -_scrollRadius && percX < 0) {
				percX = 0;
			}
			else if (percX < -_scrollRadius) {
				percX += _scrollRadius;
			}
			
			if (percY < _scrollRadius && percY > 0) {
				percY = 0;
			}
			else if (percY > _scrollRadius) {
				percY -= _scrollRadius;
			}
			if (percY > -_scrollRadius && percY < 0) {
				percY = 0;
			}
			else if (percY < -_scrollRadius) {
				percY += _scrollRadius;
			}
			vx = -percX * _maxSpeed;
			vy = -percY * _maxSpeed;
		}
		
		
		protected function scrollTarget():void {
			targetX = _rect.x;
			targetY = _rect.y;
			targetX += vx;
			targetY += vy;
			validatePositions();
			_rect.x = targetX;
			_rect.y = targetY;
			_target.scrollRect = _rect;
		}
		
		protected function validatePositions():void {
			if (targetX > maxX) {
				targetX = maxX;
			}
			else if (targetX < 0) {
				targetX = 0;
			}
			if (targetY > maxY) {
				targetY = maxY;
			}
			else if (targetY <  0) {
				targetY  = 0;
			}
		}
		
		public function get scrollType():String { return _scrollType; }
		
		public function set scrollType(value:String):void {
			_scrollType = value;
		}
		
		public function get maxSpeed():Number { return _maxSpeed; }
		
		public function set maxSpeed(value:Number):void {
			_maxSpeed = value;
		}
		
		public function get target():InteractiveObject { return _target; }
		
		public function set target(value:InteractiveObject):void {
			if (_target) {
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_target.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				_target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			_target = value;
			if (_target.stage) {
				setupStage();
			}
			else {
				_target.addEventListener(Event.ADDED_TO_STAGE, onTargetStage);
			}
		}
		
		public function get scrollRadius():Number { return _scrollRadius; }
		
		public function set scrollRadius(value:Number):void {
			_scrollRadius = value;
		}
		
		public function get scrollDuration():Number { return _scrollDuration; }
		
		public function set scrollDuration(value:Number):void {
			_scrollDuration = value;
		}
		
		public function get position():Point {
			var pos:Point = new Point( _rect.x + (stgW >> 1), _rect.y + (stgH >> 1));
			return pos;
		}
		
	}

}