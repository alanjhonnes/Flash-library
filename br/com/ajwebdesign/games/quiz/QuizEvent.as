package {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class QuizEvent extends Event{
		
		public static const QUESTION_ANSWERED:String = "answered";
		public static const RESULT_CHANGED:String = "resultChanged";
		public static const QUESTION_TIMER_STARTED:String = "questionTimerStarted";
		public static const QUESTION_TIMER_END:String = "questionTimerEnd";
		public static const QUIZ_TIMER_STARTED:String = "quizTimerStarted";
		public static const QUIZ_TIMER_END:String = "quizTimerEnd";
		static public const ANSWERED:String = "answered";
		
		public function QuizEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			
		}
		
	}

}