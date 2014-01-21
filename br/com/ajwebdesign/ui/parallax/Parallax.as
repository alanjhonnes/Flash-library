package br.com.ajwebdesign.ui.parallax {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import temple.core.CoreBitmap;
	import temple.core.CoreSprite;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class Parallax extends CoreBitmap {
		
		public var layers:Vector.<ParallaxLayer>;
		private var _scaleToStage:Boolean;
		private var _bitmap:Bitmap;
		private var _bitmapData:BitmapData;
		private var _scrollSpeed:Number;
		private var repeatH:Boolean;
		private var repeatV:Boolean;
		private var _scrollRadius:Number;
		private var percX:Number;
		private var percY:Number;
		private var vx:Number;
		private var vy:Number;
		private var _maxSpeed:Number;
		private var layerCount:int = 0;
		private var stgW:int;
		private var stgH:int;
		private var xCenter:int;
		private var yCenter:int;
		
		public static const TOP:int = 0;
		public static const RIGHT:int = 1;
		public static const BOTTOM:int = 2;
		public static const LEFT:int = 3;
		
		override public function destruct():void {
			if (hasEventListener(Event.ADDED_TO_STAGE)) {
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			if (hasEventListener(Event.REMOVED_FROM_STAGE)) {
				removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			}
			if (_scaleToStage) {
				stage.removeEventListener(Event.RESIZE, onStageResize);
			}
			layers = null;
			super.destruct();
		}
		
		public function Parallax(width:Number, height:Number, scaleToStage:Boolean = false, maxSpeed:Number = 30, radius:Number = 0.3, repeatHorizontally:Boolean = true, repeatVertically:Boolean = false ) {
			super(new BitmapData(width, height, true), PixelSnapping.AUTO, true);
			layers = new Vector.<ParallaxLayer>();
			_scaleToStage = scaleToStage;
			bitmapData = new BitmapData(width, height, true);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			repeatH = repeatHorizontally;
			repeatV = repeatVertically;
			_scrollRadius = radius;
			_maxSpeed = maxSpeed;
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			onStageResize();
			if (_scaleToStage) {
				stage.addEventListener(Event.RESIZE, onStageResize);
			}
			alignLayers();
		}
		
		private function onStageResize(e:Event = null):void {
			stgW = stage.stageWidth;
			stgH = stage.stageHeight;
			xCenter = stgW >> 1;
			yCenter = stgH >> 1;
			alignLayers();
			bitmapData = new BitmapData(stgW, stgH, true, 0x00000000);
			update();
		}
		
		public function autoScroll():void {
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function stopAutoScroll():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function alignLayers():void {
			var i:int = 0;
			var j:int = layers.length;
			for ( i; i < j; i++) {
				var layer:ParallaxLayer = layers[i];
				var alignment:int = layer.alignment;
				switch(alignment) {
					case TOP: {
						layer.y = 0;
						break;
					}
					case BOTTOM: {
						layer.y = stgH - layer.height;
						break;
					}
				}
			}
		}
		
		private function onEnterFrame(e:Event):void {
			var distX:Number = xCenter - stage.mouseX;
			var distY:Number = yCenter - stage.mouseY;
			//calculates the distance percentage from the center to the boundaries
			percX = distX / xCenter;
			percY = distY / yCenter;
			/*
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
			}*/
			vx = -percX * _maxSpeed;
			vy = -percY * _maxSpeed;
			scroll(vx, vy);
		}
		
		public function update():void {
			bitmapData.lock();
			bitmapData.fillRect(bitmapData.rect, 0x00000000);
			var i:int = 0;
			var layer:ParallaxLayer;
			for ( i; i < layerCount; i++) {
				layer = layers[i];
				layer.copyScrolledBitmap(bitmapData, stgW, stgH);
			}
			bitmapData.unlock();
		}
		
		private function onRemovedFromStage(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function addLayer(layer:ParallaxLayer):void {
			layers.push(layer);
			var alignment:int = layer.alignment;
			switch(alignment) {
				case TOP: {
					layer.y = 0;
					break;
				}
				case BOTTOM: {
					layer.y = stgH - layer.height;
					break;
				}
			}
			layers.sort(sortLayers);
			layerCount++;
		}
		
		public function get scaleToStage():Boolean {
			return _scaleToStage;
		}
		
		public function set scaleToStage(value:Boolean):void {
			_scaleToStage = value;
		}
		
		private function sortLayers(a:ParallaxLayer, b:ParallaxLayer):Number {
			return b.depth - a.depth;
		}
		
		public function scroll(vx:int, vy:int = 0):void {
			var i:int = 0;
			var layer:ParallaxLayer;
			for ( i; i < layerCount; i++) {
				layer = layers[i];
				var result:Number = layer.x + layer.offsetX + vx / layer.depth;
				layer.x = result;
			}
			update();
		}
		
	}

}