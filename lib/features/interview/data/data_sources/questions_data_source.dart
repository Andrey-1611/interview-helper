import 'dart:math';
import 'package:interview_master/core/constants/questions.dart';
import 'package:interview_master/features/interview/data/repositories/questions_repository.dart';

class QuestionsDataSource implements QuestionsRepository {
  final Random random;
  late List<String> _selectedQuestions;
  final List<String> _pageQuestions = [];
  final questions = FlutterInterviewQuestions();

  QuestionsDataSource(this.random);

  @override
  List<String> getQuestions(int difficulty) {
    try {
      if (_pageQuestions.isEmpty) {
        switch (difficulty) {
          case 1:
            _selectedQuestions = questions.flutterInterviewQuestionsJunior;
          case 2:
            _selectedQuestions = questions.flutterInterviewQuestionsMiddle;
          case 3:
            _selectedQuestions = questions.flutterInterviewQuestionsSenior;
        }

        for (int i = 0; i < 10; i++) {
          final selectedQuestionIndex = random.nextInt(
            _selectedQuestions.length,
          );
          _pageQuestions.add(_selectedQuestions[selectedQuestionIndex]);
        }
      }
      return _pageQuestions;
    } catch (e) {
      rethrow;
    }
  }
}
