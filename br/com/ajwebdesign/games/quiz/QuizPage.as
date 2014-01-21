package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Alan Jhonnes
	 */
	[Event(name="answered", type="QuizEvent")]
	public class QuizPage extends Sprite {
		
		public var correctQuestion:int;
		public var answeredIndex:int = 0;
		
		public var offsetY:int = 20;
		
		public var hasAnswered:Boolean = false;
		
		public var questionIndex:int;
		private var answers:Array = [];
		public var answersMultiplier:Array = [];
		
		public function QuizPage(index:int) {
			questionIndex = index;
		}
		
		public function addAnswerField(answer:String):void {
			var answerCount:int = answers.length;
			var quizAnswer:QuizAnswer = new QuizAnswer(answer, answerCount);
			if (answerCount > 0) {
				quizAnswer.y = height + offsetY;
			}
			addChild(quizAnswer);
			answers.push(quizAnswer);
			quizAnswer.addEventListener(MouseEvent.CLICK, onAnswerClick, false, 0, true);
		}
		
		private function onAnswerClick(e:MouseEvent):void {
			var quizAnswer:QuizAnswer = QuizAnswer(e.currentTarget);
			var answerCount:int = answers.length;
			for (var i:int = 0; i < answerCount; i++) {
				if (i != quizAnswer.index) {
					answers[i].checked = false;
				}
				else {
					answers[i].checked = true;
				}
			}
			answeredIndex = quizAnswer.index;
			quizAnswer.checked = true;
			hasAnswered = true;
			dispatchEvent(new QuizEvent(QuizEvent.ANSWERED));
			Quiz.getInstance().answers[questionIndex] = answeredIndex;
			Quiz.getInstance().propagateResult();
		}
		
		
		
	}

}