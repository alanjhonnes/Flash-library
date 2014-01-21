package {
	import flash.events.EventDispatcher;
	import temple.core.CoreSprite;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class QuizAnswer extends CoreSprite {
		
		public var multiplier:Number;
		public var text:String;
		
		public function QuizAnswer(text:String, multiplier:Number) {
			this.text = text;
			this.multiplier = multiplier;
		}
		
		
	}

}