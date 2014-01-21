package br.com.ajwebdesign.ui.scrollers {
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import fl.motion.easing.Circular;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
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
		private var lastMouseY:Number;
		private var lastMouseX:Number;
		public var targetPosX:Number;
		public var targetPosY:Number;
		
		protected var _target:Sprite;
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
		public static const MOUSE_DRAG:String = "mouseDrag"
		
		protected var _zoom:Boolean;
		protected var _minZoom:Number;
		protected var _outsideZoom:Number;
		protected var currentZoom:Number = 1;
		protected var maxRealSpeed:Number;
		protected var oldZoom:Number = 1;
		protected var oldPosition:Point = new Point(0, 0);
		protected var _position:Point = new Point(0, 0);
		
		override public function destruct():void {
			if (_target.hasEventListener(Event.ENTER_FRAME)) {
				_target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			if (stage.hasEventListener(MouseEvent.MOUSE_DOWN)) {
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			if (stage.hasEventListener(MouseEvent.MOUSE_UP)) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			if (_target.hasEventListener(MouseEvent.MOUSE_WHEEL)) {
				_target.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
			_target = null;
			_trackTarget = null;
			_trackPoint = null;
			oldPosition = null;
			_position = null;
			stage.removeEventListener(Event.RESIZE, onStageResize);
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
		public function BackgroundScroll(target:Sprite, scrollType:String = "enterFrame", maxSpeed:Number = 30,  radius:Number = 0.5, enableZoom:Boolean = false) {
			_target = target;
			targetW = _target.width;
			targetH = _target.height;
			_maxSpeed = maxSpeed;
			maxRealSpeed = _maxSpeed;
			_scrollType = scrollType;
			_scrollRadius = radius;
			_zoom = enableZoom;
			oldZoom = currentZoom = _target.scaleX;
			if (_target.stage) {
				setupStage();
			}
			else {
				_target.addEventListener(Event.ADDED_TO_STAGE, onTargetStage);
			}
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
			targetX = (targetW  * percX) - xCenter;
			targetY = (targetH  * percY) - yCenter;
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
				if (unlockAfterComplete) {
					unlock();
				}
			}
		}
		
		private function updateRect():void {
			_target.scrollRect = _rect;
		}
		
		/** Centers the target on stage */
		public function centerTarget():void {
			/*
			targetX = (targetW  >> 1) - stgW * 0.5;
			targetY = (targetH  >> 1) - stgH * 0.5;
			validatePositions();
			_rect.x = targetX;
			_rect.y = targetY;
			_target.scrollRect = _rect;
			*/
			position = new Point(targetW >> 1, targetY >> 1);
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
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, onStageResize);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_target.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			if (_zoom) {
				_target.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
			calculateBoundaries();
		}
		
		/**
		 * @TODO stop the scrolling
		 * @param	e
		 */
		private function onMouseLeave(e:Event):void {
			//stop scrolling
		}
		
		private function onStageResize(e:Event):void {
			calculateBoundaries();
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			if (!locked) {
				var delta:Number = e.delta * 0.01;
				adjustZoom(delta);
			}
		}
		
		protected function onEnterFrame(e:Event):void {
			if (!isTracking && !locked) {
				if (_scrollType == ENTER_FRAME || (_scrollType == MOUSE_DOWN && mouseDown)) {
					scrollTarget();
				}
				else if (_scrollType == MOUSE_DRAG && mouseDown) {
					var deltaX:Number = lastMouseX - mouseX;
					var deltaY:Number = lastMouseY - mouseY;
					position = new Point(_position.x + deltaX,_position.y + deltaY);
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
			if ( _scrollType == MOUSE_DRAG) {
				_target.buttonMode = true;
				//TODO Implement mouse dragging functionality
				lastMouseX = _target.mouseX;
				lastMouseY = _target.mouseY;
			}
		}
		
		private function onMouseUp(e:MouseEvent):void {
			mouseDown = false;
			if (_scrollType == MOUSE_DRAG) {
				_target.buttonMode = false;
			}
		}
		
		protected function onMouseMove(e:MouseEvent):void {
			if ( _scrollType == ENTER_FRAME || _scrollType == MOUSE_DOWN ) {
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
				vx = -percX * maxRealSpeed;
				vy = -percY * maxRealSpeed;
			}
			//mouse drag
			else if(_scrollType == MOUSE_DRAG && mouseDown){
				
			}
			
		}
		
		private function adjustZoom(delta:Number = 0):void {
			zoom += delta;
		}
		
		protected function calculateBoundaries():void {
			var minY:Number;
			var minX:Number;
			stgW = stage.stageWidth;
			stgH = stage.stageHeight;
			xCenter = stgW * 0.5;
			yCenter = stgH * 0.5;
			maxX = targetW - stgW / currentZoom;
			maxY = targetH - stgH / currentZoom;
			if (maxX < 0 || maxY < 0) {
				if (maxX < 0 && maxY < 0) {
					if (maxX < maxY) {
						currentZoom = stgH / targetH;
					}
					else {
						currentZoom = stgW / targetW;
					}
				}
				else if (maxX < 0) {
					currentZoom = stgW / targetW;
				}
				else if(maxY < 0) {
					currentZoom = stgH / targetH;
				}
				vx = 0;
				vy = 0;
				_rect.width = stgW / currentZoom;
				_rect.height = stgH / currentZoom;
				
				minX = stgW / targetW;
				minY = stgH / targetH;
				if (minX > minY) {
					minZoom = minX;
				}
				else {
					minZoom = minY;
				}
			}
			else {
				vx = 0;
				vy = 0;
				_rect.width = stgW / currentZoom;
				_rect.height = stgH / currentZoom;
				minX = stgW / targetW;
				minY = stgH / targetH;
				if (minX > minY) {
					minZoom = minX;
				}
				else {
					minZoom = minY;
				}
			}
			if ( currentZoom < minZoom) {
				currentZoom = minZoom;
			}
			_target.scaleX = currentZoom;
			_target.scaleY = currentZoom;
			_rect.width = stgW / currentZoom + 1;
			_rect.height = stgH / currentZoom +1;
			_rect.x = oldPosition.x - xCenter / currentZoom;
			_rect.y = oldPosition.y - yCenter / currentZoom;
			maxRealSpeed = maxSpeed / currentZoom;
			scrollTarget();
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
			_position.x = _rect.x + (xCenter) / currentZoom;
			_position.y = _rect.y + (yCenter) / currentZoom;
		}
		
		protected function validatePositions():void {
			if (maxX < 0) {
				maxX = 0;
			}
			if (maxY < 0) {
				maxY = 0;
			}
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
		
		/**
		 * 
		 * @param	rect A rectangle representing the area visible on the screen,zooming in or out to fit it to the stage
		 */
		public function zoomTo(rect:Rectangle, unlockAfterComplete:Boolean = false, zoomInside:Boolean = false, zoomOut:Boolean = true, duration:Number = NaN):void {
			lock();
			var time:Number;
			if (!isNaN(duration)) {
				time = duration;
			}
			else {
				time = _scrollDuration;
			}
			var zoomX:Number = 1 / (rect.width / stgW);
			var zoomY:Number = 1 / (rect.height / stgH);
			var posX = rect.x + (rect.width >> 1);
			var posY = rect.y + (rect.height >> 1);
			var targetZ:Number;
			if (zoomX > zoomY) {
				if (zoomInside) {
					targetZ = zoomX;
				}
				else {
					targetZ = zoomY;
				}
			}
			else {
				if (zoomInside) {
					targetZ = zoomY;
				}
				else {
					targetZ = zoomX;
				}
			}
			
			if (zoomOut) {
				targetPosX = targetW >> 1;
				targetPosY = targetH >> 1;
				TweenMax.to(this, time, { zoom:_minZoom, ease:Circular.easeInOut } );
				TweenMax.to(this, time, { zoom:targetZ, targetPosX:posX, targetPosY:posY, onUpdate:updatePosition, delay:_scrollDuration + 0.4, ease:Circular.easeInOut } );
			}
			else {
				targetPosX = _position.x;
				targetPosY = _position.y;
				TweenMax.to(this, time, { zoom:targetZ, targetPosX:posX, targetPosY:posY, onUpdate:updatePosition, ease:Circular.easeInOut } );
			}
			
			
			if (unlockAfterComplete) {
				unlock();
			}
		}
		
		public function zoomToTarget(target:DisplayObject, useBounds:Boolean = true, zoomInside:Boolean = false, zoomOut:Boolean = false, duration:Number = NaN, unlockAfterComplete:Boolean = false, leftPadding:Number = 0, rightPadding:Number = 0, topPadding:Number = 0, bottomPadding:Number = 0 ):void {
			var rect:Rectangle;
			if (useBounds) {
				rect = target.getBounds(target.parent);
			}
			else {
				rect = new Rectangle(target.x, target.y, target.width, target.height);
			}
			rect.x -= leftPadding;
			rect.y -= topPadding;
			rect.width += leftPadding + rightPadding;
			rect.height += topPadding + bottomPadding;
			
			if (isNaN(duration)) {
				duration = _scrollDuration;
			}
			zoomTo(rect, unlockAfterComplete, zoomInside, zoomOut, duration );
		}
		
		public function zoomOut(unlockAfterComplete:Boolean = false):void {
			lock();
			if (unlockAfterComplete) {
				TweenMax.to(this, _scrollDuration, { zoom:_minZoom, ease:Circular.easeInOut, onComplete:unlock } );
			}
			else {
				TweenMax.to(this, _scrollDuration, { zoom:_minZoom, ease:Circular.easeInOut } );
			}
		}
		
		protected function updatePosition():void {
			_position.x = targetPosX;
			_position.y = targetPosY;
			calculateBoundaries();
		}
		
		public function get scrollType():String { return _scrollType; }
		
		public function set scrollType(value:String):void {
			_scrollType = value;
		}
		
		public function get maxSpeed():Number { return _maxSpeed; }
		
		public function set maxSpeed(value:Number):void {
			_maxSpeed = value;
			maxRealSpeed = _maxSpeed / currentZoom;
		}
		
		public function get target():Sprite { return _target; }
		
		public function set target(value:Sprite):void {
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
			//_position.x = _rect.x + (stgW >> 1) / currentZoom;
			//_position.y = _rect.y + (stgH >> 1) / currentZoom;
			return _position;
		}
		
		public function set position(value:Point):void {
			_position = value;
			oldPosition = position;
			calculateBoundaries();
		}
		
		public function get mouseX():Number {
			return _target.mouseX;
		}
		
		public function get mouseY():Number {
			return _target.mouseY;
		}
		
		public function get insideZoom():Number {
			return 0;
		}
		
		public function get minZoom():Number {
			return _minZoom;
		}
		
		public function set minZoom(value:Number):void {
			_minZoom = value;
		}
		
		public function set zoom(value:Number):void {
			oldZoom = currentZoom;
			oldPosition = position;
			currentZoom = value;
			calculateBoundaries();
		}
		
		public function get zoom():Number {
			return currentZoom;
		}
		
		public function get scrollRect():Rectangle {
			return _rect;
		}
		
	}

}