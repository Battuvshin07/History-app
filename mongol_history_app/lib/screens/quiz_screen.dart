import 'dart:convert';
import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/quiz.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Quiz> _quizzes = [];
  bool _isLoading = true;
  int _currentQuizIndex = 0;
  int? _selectedAnswer;
  int _score = 0;
  bool _quizCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    setState(() => _isLoading = true);
    final quizzes = await DatabaseHelper.instance.readAllQuizzes();
    setState(() {
      _quizzes = quizzes;
      _isLoading = false;
    });
  }

  void _nextQuestion() {
    if (_selectedAnswer == null) return;

    if (_selectedAnswer == _quizzes[_currentQuizIndex].correctAnswer) {
      _score++;
    }

    if (_currentQuizIndex < _quizzes.length - 1) {
      setState(() {
        _currentQuizIndex++;
        _selectedAnswer = null;
      });
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentQuizIndex = 0;
      _selectedAnswer = null;
      _score = 0;
      _quizCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_quizzes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'quiz олдсонгүй',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadSampleData,
              icon: const Icon(Icons.add),
              label: const Text('Туршилтын quiz нэмэх'),
            ),
          ],
        ),
      );
    }

    if (_quizCompleted) {
      return _buildResultScreen();
    }

    return _buildQuizScreen();
  }

  Widget _buildQuizScreen() {
    final quiz = _quizzes[_currentQuizIndex];
    final answers = jsonDecode(quiz.answers) as List<dynamic>;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Явц
          LinearProgressIndicator(
            value: (_currentQuizIndex + 1) / _quizzes.length,
            backgroundColor: Colors.grey.shade300,
            color: Colors.blue,
          ),
          const SizedBox(height: 8),
          Text(
            'Асуулт ${_currentQuizIndex + 1} / ${_quizzes.length}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Асуулт
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                quiz.question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Хариултууд
          Expanded(
            child: ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedAnswer == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedAnswer = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue.shade100
                            : Colors.grey.shade100,
                        border: Border.all(
                          color:
                              isSelected ? Colors.blue : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? Colors.blue : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade400,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              answers[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected
                                    ? Colors.blue.shade900
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Дараагийн товч
          ElevatedButton(
            onPressed: _selectedAnswer != null ? _nextQuestion : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _currentQuizIndex < _quizzes.length - 1
                  ? 'Дараагийнх'
                  : 'Дуусгах',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = (_score / _quizzes.length * 100).round();
    final passed = percentage >= 60;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              passed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 100,
              color: passed ? Colors.amber : Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              passed ? 'Баяр хүргэе!' : 'Дахин оролдоорой',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Таны оноо: $_score / ${_quizzes.length}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: passed ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _resetQuiz,
              icon: const Icon(Icons.refresh),
              label: const Text('Дахин эхлэх'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSampleData() async {
    final sampleQuizzes = [
      Quiz(
        question: 'Чингис хаан хэдэн онд төрсөн бэ?',
        answers: jsonEncode(['1155', '1162', '1178', '1180']),
        correctAnswer: 1,
      ),
      Quiz(
        question: 'Монголын эзэнт гүрэн хэдэн онд байгуулагдсан бэ?',
        answers: jsonEncode(['1203', '1206', '1210', '1215']),
        correctAnswer: 1,
      ),
      Quiz(
        question: 'Чингис хааны жинхэнэ нэр юу байсан бэ?',
        answers: jsonEncode(['Тэмүүжин', 'Бөртэ', 'Есүй', 'Жамух']),
        correctAnswer: 0,
      ),
    ];

    for (var quiz in sampleQuizzes) {
      await DatabaseHelper.instance.createQuiz(quiz);
    }

    await _loadQuizzes();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Туршилтын quiz нэмэгдлээ')),
      );
    }
  }
}
