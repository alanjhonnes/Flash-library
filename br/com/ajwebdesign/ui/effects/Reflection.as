package br.com.ajwebdesign.ui.effects {
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	/**
	 * @author Alan Jhonnes
	 */
	public class Reflection extends Sprite{
		
		//Target object we are reflecting
		private var _target:Sprite;
		//the BitmapData object that will hold a visual copy of the mc
		private var bitmapData:BitmapData;
		//the BitmapData object that will hold the reflected image
		private var reflectionBitmap:Bitmap;
		//the clip that will act as out gradient mask
		private var gradientMask:Sprite = new Sprite();
		//how often the reflection should update (if it is video or animated)
		private var _updateTime:Number;
		//the size the reflection is allowed to reflect within
		
		//the distance the reflection is vertically from the mc
		private var _distance:Number = 0;
		
		private var _alpha:Number;
		
		private var _ratio:int;
		
		private var targetW:Number;
		private var targetH:Number;
		private var updateInt:uint;
	
		/**
		 * Creates a reflection below the target object
		 * @param	target The object to be reflected
		 * @param	alpha The initial alpha value 
		 * @param	ratio The ratio of the reflection
		 * @param	updateTime
		 * @param	distance
		 */
		public function Reflection(target:Sprite, alpha:Number = 0.8, ratio:Number = 0.8, updateTime:Number = -1, distance:Number = 0){
			//the clip being reflected
			_target = target;
			//the alpha level of the reflection clip
			_alpha = alpha;
			//the ratio opaque color used in the gradient mask
			_ratio = int(ratio * 255);
			_updateTime = updateTime;
			//the distance the reflection starts from the bottom of the mc
			_distance = distance;
			
			//store width and height of the clip
			targetW = _target.width;
			targetH = _target.height;
			
			//create the BitmapData that will hold a snapshot of the movie clip
			bitmapData = new BitmapData(targetW, targetH, true, 0xFFFFFF);
			bitmapData.draw(_target);
			
			//create the BitmapData the will hold the reflection
			reflectionBitmap = new Bitmap(bitmapData);
			//flip the reflection upside down
			reflectionBitmap.scaleY = -1;
			//move the reflection to the bottom of the movie clip
			reflectionBitmap.y = (targetH * 2) + distance;
			_target.addChild(reflectionBitmap);
			_target.addChild(gradientMask);
			//set the values for the gradient fill
			var fillType:String = GradientType.LINEAR;
		 	var colors:Array = [0xFFFFFF, 0xFFFFFF];
		 	var alphas:Array = [alpha, 0];
		  	var ratios:Array = [0, _ratio];
			var spreadMethod:String = SpreadMethod.PAD;
			//create the Matrix and create the gradient box
		  	var matrix:Matrix = new Matrix();
			matrix.createGradientBox(targetW, targetH, Math.PI * 0.5, 0, 0);
		  	//create the gradient fill
			gradientMask.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, spreadMethod);  
		    gradientMask.graphics.drawRect(0,0, targetW, targetH);
			//position the mask over the reflection clip			
			gradientMask.y = reflectionBitmap.y - reflectionBitmap.height;
			//cache clip as a bitmap so that the gradient mask will function
			gradientMask.cacheAsBitmap = true;
			reflectionBitmap.cacheAsBitmap = true;
			//set the mask for the reflection as the gradient mask
			reflectionBitmap.mask = gradientMask;
			
			//if we are updating the reflection for a video or animation do so here
			if(updateTime > -1){
				updateInt = setInterval(update, updateTime);
			}
		}
		
		public function setBounds(w:Number,h:Number):void{
			//allows the user to set the area that the reflection is allowed
			//this is useful for clips that move within themselves
			targetW = w;
			targetH = h;
			gradientMask.width = targetW;
			redrawBMP();
		}
		public function redrawBMP():void {
			bitmapData.dispose();
			bitmapData = new BitmapData(targetW, targetH, true, 0xFFFFFF);
			bitmapData.draw(_target);
		}
		
		public function update():void {
			//updates the reflection to visually match the movie clip
			bitmapData = new BitmapData(targetW, targetH, true, 0xFFFFFF);
			bitmapData.draw(_target);
			reflectionBitmap.bitmapData = bitmapData;
		}
		public function destroy():void{
			//provides a method to remove the reflection
			_target.removeChild(reflectionBitmap);
			_target.removeChild(gradientMask);
			reflectionBitmap = null;
			bitmapData.dispose();
			clearInterval(updateInt);
		}
		
		public function get ratio():Number { return _ratio / 255; }
		
		public function set ratio(value:Number):void {
			_ratio = value * 255;
		}
	}
}