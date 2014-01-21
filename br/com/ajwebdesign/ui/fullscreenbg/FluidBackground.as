/*
Copyright (c) 2010 Alan Jhonnes - alanjhonnes@hotmail.com - ajwebdesign.com.br

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package br.com.ajwebdesign.ui.fullscreenbg 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Fluid Background class for full-screen background images or patterns.
	 * @author Alan Jhonnes 
	 * 
	 */
	public class FluidBackground extends Sprite {
		
		/* Here we're using protected variables and methods.
		They are not accessible for other objects,but if we want to extend and override them on a subclass,we can. */
		protected var bitmap:Bitmap;
		protected var _keepAspect:Boolean;
		protected var _isPattern:Boolean;
		//original image measures.
		protected var origW:int;
		protected var origH:int;
		//stage measures are set here so we don't have to keep redeclaring them.
		protected var stgW:int;
		protected var stgH:int;
		
		/**
		 * Constructor.
		 * @param	image The BitmapData to be manipulated.
		 * @param	keepAspect Wheter we should keep the same ratio width/height or not when stretching the image.
		 * @param	isPattern If we are using this image as a pattern or not.
		 */
		public function FluidBackground(image:BitmapData, keepAspect:Boolean = true, isPattern:Boolean = false) {
			//instantiate our bipmap with the bitmap data we got,setting smoothing to true.
			bitmap = new Bitmap(image, PixelSnapping.AUTO, true);
			_keepAspect = keepAspect;
			_isPattern = isPattern;
			//If its a pattern,we don't need to put it on the display list.
			if (isPattern == false) {
				addChild(bitmap);
			}
			origW = bitmap.width;
			origH = bitmap.height;
			//we need to add a listener to the stage,because we'll be using it.If we don't do this,we can get runtime errors.
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//add a listener to the resize event and call it.
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();			
		}
		
		protected function onResize(e:Event = null):void {
			//here we refresh our stage measures since they got changed
			stgW = stage.stageWidth;
			stgH = stage.stageHeight;
			//and run the correct function
			if (_isPattern == true) {
				setPattern();
			}
			else {
				setImage();
			}
		}
		
		/**
		 * Fills the background with the image as a pattern.
		 */
		public function setPattern():void {
			graphics.clear();
			//here we will fill a rectangle representing the whole stage with the pattern,setting smoothing and repeat to true.
			graphics.beginBitmapFill(bitmap.bitmapData, null, true, true);
			//move the pointer to the top-left position
			graphics.moveTo(0, 0);
			//draw a line to the top-right
			graphics.lineTo(stgW, 0);
			//draw a line to the bottom-right
			graphics.lineTo(stgW, stgH);
			//draw a line to the bottom-left
			graphics.lineTo(0, stgH);
			//draw a line to the top-left
			graphics.lineTo(0, 0);
			//stops the fill
			graphics.endFill();
		}
		
		/**
		 * Sets an image as the background.
		 */
		public function setImage():void {
			//the resulting measures after the calculations
			var w:Number;
			var h:Number;
			if (_keepAspect == false) {
				//quite obvious i supose.
				w = stgW;
				h = stgH;
			}
			//if we're keeping the aspect ratio,we need to run some calculations
			else {
				//how many times the stage's width is bigger than the image's width
				var stgWRatio:Number = stgW / origW;
				//how many times the stage's height is bigger than the image's height
				var stgHRatio:Number = stgH / origH;
				//if keepAspect equals true,we run some transformations to stretch the image correctly.
				//if the image width is bigger than its height,we'll stretch the width further and max the height for the stage height.
				if (origW > origH) {
					w = origW * stgHRatio;
					h = stgH;
					//if the width is still lower than the stage width,we'll max it out,and then max out the height.
					if (w < stgW) {
						w = stgW;
						//h = origH * stgWRatio;
					}
				}
				//if the height is bigger than the width,then we'll do the same thing,but with inverted values.
				else if(origH > origW) {
					h = origH * stgWRatio;
					w = stgW;
					if (h < stgH) {
						h = stgH;
						//w = origW * stgHRatio;
					}
				}
				//finally,if the width/height are the same
				else {
					//remember that we're keeping the ratio even on this case.
					w = origW * stgHRatio;
					h = origH * stgWRatio;
				}
			}
			//now we resize the bitmap according to our calculations.
			bitmap.width = w;
			bitmap.height = h;
		}
		
	}
}