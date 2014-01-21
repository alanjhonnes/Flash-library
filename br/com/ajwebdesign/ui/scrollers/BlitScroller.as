package br.com.ajwebdesign.ui.scrollers {
	import com.greensock.BlitMask;
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import temple.core.CoreSprite;
	
	/**
	 * TODO
	 * @author Alan Jhonnes
	 */
	public class BlitScroller extends CoreSprite {
		
		private var blit:BlitMask;
		
		override public function destruct():void {
			blit.dispose();
			super.destruct();
		}
		
		public function BlitScroller(target:DisplayObject, w:Number, h:Number, smoothScrolling:Boolean = true) {
				blit = new BlitMask(target, 0, 0, w, h, true, false);
				
		}
		
	}

}