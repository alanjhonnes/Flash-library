package br.com.ajwebdesign.ui.scrollers
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import flash.display.DisplayObject;
	
	/**
	 * Smooth Mouse Scrolling class based on the mouse percentage over the Mask.
	 * @author Alan
	 * @example var myMouseScroll:MouseScroll = new MouseScroll(myMovieClip,width,height);
	 * addChild(myMouseScroll);
	 */
	public class MouseScroll extends MovieClip
	{
		public var content:MovieClip;
		protected var maskHeight:Number;
		protected var maskWidth:Number;
		protected var masker:Shape;
		protected var mouseYPos:Number;
		protected var mouseXPos:Number;
		protected var yPercentage:Number;
		protected var xPercentage:Number;
		protected var scrollYPosition:Number;
		protected var scrollXPosition:Number;
		protected var scrollY:Boolean;
		protected var scrollX:Boolean;
		
		
		/**
		 * 
		 * @param	content 	The MovieClip to be scrolled.
		 * @param	width		The Mask Width.
		 * @param	height 		The Mask Height.
		 * @param 	scrollToX	If this scrolls in the X axis.
		 * @param 	scrollToY 	If this scrolls in the Y axis.
		 */
		public function MouseScroll(object:DisplayObject, width:Number, height:Number, scrollToX:Boolean = true , scrollToY:Boolean = true ):void {
			content  = new MovieClip();
			content.addChild(object);
			object.x = 0;
			object.y = 0;
			addChild(content);
			maskHeight = height;
			maskWidth = width;
			drawMask();
			scrollX = scrollToX;
			scrollY = scrollToY;
			addEventListener(MouseEvent.MOUSE_MOVE, scroll);
		}
		
		public function scroll(event:MouseEvent):void {
			if (scrollY == true) {
				if (totalHeight > maskHeight) {
					mouseYPos = masker.mouseY;
					yPercentage = mouseYPos / maskHeight;
					scrollYPosition = yPercentage * (totalHeight - maskHeight);	
				}
			}
			if (scrollX == true) {
				if (totalWidth > maskWidth) {
					mouseXPos = masker.mouseX;
					xPercentage = mouseXPos / maskWidth;
					scrollXPosition = xPercentage * (totalWidth - maskWidth);
				}
			}
			TweenLite.to(content, 1, { x: -scrollXPosition, y: -scrollYPosition, ease:Quad.easeOut } );
		}
		
		/**
		 * Manually scroll the container by setting the scroll amount.
		 * @param	scrollX The amount to be scrolled horizontally.
		 * @param	scrollY The amount to be scrolled vertically.
		 */
		public function manualScroll(scrollX:Number = 0, scrollY:Number = 0) {
			if (totalWidth > maskWidth) {
				scrollXPosition = scrollX;
			}
			if (totalHeight > maskHeight) {
				scrollYPosition = scrollY;	
			}
			TweenLite.to(content, 1, { x: -scrollXPosition, y: -scrollYPosition, ease:Quad.easeOut } );
		}
		
		/**
		 * Draws the mask of the content.
		 */
		private function drawMask():void {
			masker = new Shape();
			masker.graphics.beginFill(0x000000);	
			masker.graphics.drawRect(0, 0, maskWidth, maskHeight);
			masker.graphics.endFill();
			addChild(masker);
			content.mask = masker;
		}
		/**
		 * @return Total Height of the content.
		 */
		public function get totalHeight():Number { 
			return content.height; 
		}
		
		/**
		 * @return Total Width of the content.
		 */
		public function get totalWidth():Number {
			return content.width;
		}
	}
}