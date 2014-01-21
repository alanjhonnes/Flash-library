package  {
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import temple.core.CoreEventDispatcher;
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	public class QuizQuestion extends CoreEventDispatcher {
		
		private var _text:String;
		private var _value:Number;
		private var _timelimit:int;
		private var _answers:Array = [];
		private var _score:Number = 0;
		private var selectedAnswer:QuizAnswer = null;
		private var timer:Timer;
		private var _isAnswered:Boolean = false;
		
		override public function destruct():void {
			timer.removeEventListener(TimerEvent.TIMER, onTimerTick);
			timer.stop();
			timer = null;
			super.destruct();
		}
		
		public function QuizQuestion(question:String, answers:Array, value:Number = 1, timelimit:int = 60 ) {
			_text = question;
			_value = value;
			_timelimit = timelimit;
			_answers = answers;
			timer = new Timer(_timelimit, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimerTick);
		}
		
		public function setAnswer(index:int):void {
			selectedAnswer = _answers[index];
			isAnswered = true;
		}
		
		
		
		public function calculateScore(indexAnswered:int, timeRemaining:int):Number { 
			if (selectedAnswer) {
				_score = selectedAnswer.multiplier * (_value + timeRemaining);
			}
			return _score;
		}
		
		public function startTimer():void {
			timer.reset();
			timer.start();
			dispatchEvent(new QuizEvent(QuizEvent.QUESTION_TIMER_STARTED));
		}
		
		private function onTimerTick(e:TimerEvent):void {
			timer.stop();
			timer.reset();
			dispatchEvent(new QuizEvent(QuizEvent.QUESTION_TIMER_END));
		}
		
		public function get text():String { return _text; }
		
		public function get value():Number { return _value; }
		
		public function get timelimit():int { return _timelimit; }
		
		public function get score():Number { return _score; }
		
		public function get isAnswered():Boolean { return _isAnswered; }
		
	}

}