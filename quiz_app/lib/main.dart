import 'package:flutter/material.dart';

// Question class with final properties
class Question {
	final String text;
	final List<String> options;
	final int correctIndex;

	const Question({
		required this.text,
		required this.options,
		required this.correctIndex,
	});
}

// Quiz data: List of Question objects
const List<Question> questions = [
	Question(
		text: 'What is the capital of Pakistan?',
		options: ['Lahore', 'Islamabad', 'Karachi', 'Peshawar'],
		correctIndex: 1,
	),
	Question(
		text: 'Which language is used for Flutter development?',
		options: ['Java', 'Kotlin', 'Dart', 'Swift'],
		correctIndex: 2,
	),
	Question(
		text: 'Who developed the theory of relativity?',
		options: ['Newton', 'Einstein', 'Tesla', 'Edison'],
		correctIndex: 1,
	),
	Question(
		text: 'Which planet is known as the Red Planet?',
		options: ['Earth', 'Venus', 'Mars', 'Jupiter'],
		correctIndex: 2,
	),
];

void main() {
	runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
	const QuizApp({super.key});

	@override
	Widget build(BuildContext context) {
		return const MaterialApp(
			debugShowCheckedModeBanner: false,
			home: QuizPage(),
		);
	}
}

class QuizPage extends StatefulWidget {
	const QuizPage({super.key});

	@override
	State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
	int _currentQuestion = 0;
	int _score = 0;
	bool _quizFinished = false;

	void _answerQuestion(int selectedIndex) {
		if (!_quizFinished) {
			if (selectedIndex == questions[_currentQuestion].correctIndex) {
				setState(() {
					_score++;
				});
			}
			setState(() {
				if (_currentQuestion < questions.length - 1) {
					_currentQuestion++;
				} else {
					_quizFinished = true;
				}
			});
		}
	}

	void _restartQuiz() {
		setState(() {
			_currentQuestion = 0;
			_score = 0;
			_quizFinished = false;
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Flutter Quiz App'),
				centerTitle: true,
			),
			body: Center(
				child: Padding(
					padding: const EdgeInsets.all(16.0),
					child: _quizFinished
							? ResultScreen(score: _score, total: questions.length, onRestart: _restartQuiz)
							: QuizScreen(
									question: questions[_currentQuestion],
									questionNumber: _currentQuestion + 1,
									totalQuestions: questions.length,
									onOptionSelected: _answerQuestion,
								),
				),
			),
		);
	}
}

class QuizScreen extends StatelessWidget {
	final Question question;
	final int questionNumber;
	final int totalQuestions;
	final void Function(int) onOptionSelected;

	const QuizScreen({
		super.key,
		required this.question,
		required this.questionNumber,
		required this.totalQuestions,
		required this.onOptionSelected,
	});

	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				Text(
					'Question $questionNumber of $totalQuestions',
					style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
					textAlign: TextAlign.center,
				),
				const SizedBox(height: 24),
				Text(
					question.text,
					style: const TextStyle(fontSize: 22),
					textAlign: TextAlign.center,
				),
				const SizedBox(height: 32),
				...List.generate(
					question.options.length,
					(index) => Padding(
						padding: const EdgeInsets.symmetric(vertical: 6.0),
						child: ElevatedButton(
							onPressed: () => onOptionSelected(index),
							style: ElevatedButton.styleFrom(
								padding: const EdgeInsets.symmetric(vertical: 16),
								textStyle: const TextStyle(fontSize: 18),
							),
							child: Text(question.options[index]),
						),
					),
				),
			],
		);
	}
}

class ResultScreen extends StatelessWidget {
	final int score;
	final int total;
	final VoidCallback onRestart;

	const ResultScreen({
		super.key,
		required this.score,
		required this.total,
		required this.onRestart,
	});

	@override
	Widget build(BuildContext context) {
		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			crossAxisAlignment: CrossAxisAlignment.center,
			children: [
				Text(
					'Quiz Finished!',
					style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
				),
				const SizedBox(height: 24),
				Text(
					'Your Score: $score / $total',
					style: const TextStyle(fontSize: 22),
				),
				const SizedBox(height: 32),
				ElevatedButton(
					onPressed: onRestart,
					style: ElevatedButton.styleFrom(
						padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
						textStyle: const TextStyle(fontSize: 18),
					),
					child: const Text('Restart'),
				),
			],
		);
	}
}
