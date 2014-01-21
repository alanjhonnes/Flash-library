package br.com.ajwebdesign.ui.fullscreenbg 
{
	import br.com.ajwebdesign.ui.fullscreenbg.transitions.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.errors.IOError;
	/**
	 * ...
	 * @author Alan
	 */
	public class FullScreenBackground extends MovieClip
	{
		protected var stg:Stage = this.stage;
		protected var bg:BitmapData;
		protected var image:Bitmap;
		protected var stgWidth:Number;
		protected var stgHeight:Number;
		protected var isPattern:Boolean;
		protected var loader:Loader;
		protected var imgReady:Boolean;
		
		/**
		 * Creates a fullscreen background.
		 * @param	image The bitmap image.JPG,PNG or GIF formats are supported.
		 * @param	imagePath The path to the image.If using this,the image will be loaded.
		 * @param	isPattern If the image is a pattern
		 * @param	transition The transition to be used.
		 */
		public function FullScreenBackground(image:Bitmap = null,imagePath:String = "", isPattern:Boolean = false, transition:String = "ALPHA" ) 
		{
			image.smoothing = true;
			this.isPattern = isPattern;
			this.addEventListener(BackgroundEvent.IMAGE_READY, imageReady);
			if (image != null) {
				this.image = image;
				dispatchEvent(new BackgroundEvent(BackgroundEvent.IMAGE_READY));
			}
			else if (imagePath != "") {
				loader = new Loader();
				loader.load(new URLRequest(imagePath));
				dispatchEvent(new BackgroundEvent(BackgroundEvent.LOADING));
				loader.addEventListener(Event.COMPLETE, imageLoaded);
			}
			else {
				throw new IOError("Image not found. URL = " + imagePath);
			}
		}
		
		private function imageReady(e:BackgroundEvent):void 
		{
			imgReady = true;
		}
		
		private function imageLoaded(e:Event):void 
		{
			this.image = loader.content;
			dispatchEvent(new BackgroundEvent(BackgroundEvent.IMAGE_READY));
		}
		
		
		public function changeImage(image:Bitmap = null, imagePath:String= "") {
			
		}
		
		protected function initBG(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initBG);
			stg.addEventListener(Event.RESIZE, resizeBG);
		}
		
		private function resizeBG(e:Event):void 
		{
			
		}
	}
}