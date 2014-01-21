package {
	
	import de.mightypirates.utils.Vector2D;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import temple.core.CoreEventDispatcher;
	
	/**
	 * Abstract Quiz Class
	 * @author Alan Jhonnes
	 */
	[Event(name="quizTimerStarted", type="QuizEvent")]
	[Event(name="quizTimerEnd", type="QuizEvent")]
	[Event(name="resultChanged", type="QuizEvent")]
	public class Quiz extends CoreEventDispatcher {
		
		private static var instance:Quiz;
		private var _xml:XML;
		public var questions:Array = [];
		public var answers:Array = [];
		public var scores:Array = [];
		private var _result:Number;
		private var timer:Timer;
		private var _timelimit:int;
		private var _timebonus:int;
		private var _totalQuestions:int;
		private var _currentQuestion:int;
		
		private var _startTime:Number;
		private var _timeRemaining:int;
		
		override public function destruct():void {
			instance = null;
			questions = [];
			answers = [];
			scores = [];
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onTimerTick);
			super.destruct();
		}
		
		public function Quiz(quiz:XML = null) {
			if (instance) {
				throw new Error("Quiz already initialized.");
			}
			else {
				_xml = quiz;
				parseQuiz();
			}
		}
		
		private function parseQuiz():void {
			var text:String;
			var value:Number;
			var timelimit:int;
			var answerText:String;
			var multiplier:Number;
			var answers:Array = [];
			_timelimit = _xml.@timelimit;
			_timebonus = _xml.@timebonus;
			timer.addEventListener(TimerEvent.TIMER, onTimerTick);
			for each(var question:XMLList in _xml.question) {
				answers = [];
				text = question.@text;
				value = question.@value;
				timelimit = question.@timelimit * 1000;
				_totalQuestions++;
				for each(var answer:XML in question.answer ) {
					answerText = answer.toString();
					multiplier = answer.@multiplier;
					answers.push(new QuizAnswer(answerText, multiplier));
				}
				questions.push(new QuizQuestion(text, answers, value, timelimit));
			}
		}
		
		
		public function startQuiz():void {
			_startTime = getTimer();
			timer.reset();
			timer.start();
			dispatchEvent(new QuizEvent(QuizEvent.QUIZ_TIMER_STARTED));
		}
		
		public function getNextQuestion():QuizQuestion {
			if (_currentQuestion == _totalQuestions) {
				_currentQuestion = 0;
			}
			else {
				_currentQuestion++;
			}
			return questions[_currentQuestion] as QuizQuestion;
		}
		
		public function getPreviousQuestion():QuizQuestion {
			if (_currentQuestion == 0) {
				_currentQuestion == _totalQuestions;
			}
			else {
				_currentQuestion--;
			}
			return questions[_currentQuestion] as QuizQuestion;
		}
		
		public function getQuestion(index:int):QuizQuestion {
			return questions[index] as QuizQuestion;
		}
		
		public function selectAnswer(questionIndex:int, answerIndex:int):void {
			QuizQuestion(questions[questionIndex]).setAnswer(answerIndex);
		}
		
		private function onTimerTick(e:TimerEvent):void {
			timer.stop();
			timer.reset();
			dispatchEvent(new QuizEvent(QuizEvent.QUIZ_TIMER_END));
		}
		
		public static function birth(quiz:XML = null):void {
			if (!instance) {
				instance = new Quiz(quiz);
				trace("Quiz initialized.");
			}
		}
		
		public function getResult():Number {
			var result:Number = 0;
			for each(var question:QuizQuestion in questions) {
				result += question.score;
			}
			_timeRemaining = (_startTime - getTimer()) * 0.001; 
			result += _timebonus * _timeRemaining;
			return result;
		}
		
		public function traceStats():void {
			trace("Score: " + getResult);
			trace("Time remaining: " + _timeRemaining);
			trace("Total questions: " + _totalQuestions);
			trace("Total answered: " + getAnsweredCount());
		}
		
		public function getAnsweredCount():int {
			var count:int = 0;
			for each(var question:QuizQuestion in questions) {
				if (question.isAnswered) {
					count++;
				}
			}
			return count;
		}
		
		//Destroy the current instance for garbage collection,or to create a new quiz.
		/*
		public static function destroy():void {
			instance = null;
		}
		*/
		
		public static function getInstance():Quiz {
			return instance;
		}
		
		public function propagateResult():void {
			dispatchEvent(new QuizEvent(QuizEvent.RESULT_CHANGED));
		}
		
		public function get xml():XML { return _xml; }
		
		public function set xml(value:XML):void {
			_xml = value;
		}
		
		public function get totalQuestions():int { return _totalQuestions; }
		
		public function get timelimit():int { return _timelimit; }
		
		public function get timebonus():int { return _timebonus; }
		
	}

}