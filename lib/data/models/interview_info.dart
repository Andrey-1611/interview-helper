import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:interview_master/core/constants/questions/questions_manager.dart';
import '../enums/difficulty.dart';
import '../enums/direction.dart';
import '../enums/language.dart';

class InterviewInfo extends Equatable {
  final Direction direction;
  final Difficulty difficulty;
  final Language language;
  final List<({String question, String answer})> userInputs;
  final String? id;

  const InterviewInfo({
    this.userInputs = const [],
    required this.direction,
    required this.difficulty,
    required this.language,
    this.id,
  });

  @override
  List<Object?> get props => [direction, difficulty, userInputs];

  static List<String> selectQuestions(InterviewInfo info) {
    final random = Random();
    final questions = QuestionsManager.direction(
      info.direction,
    ).questions(info.language, info.difficulty);
    final randomQuestions = List<String>.from(questions)..shuffle(random);
    return randomQuestions.take(10).toList();
  }

  static List<String> searchQuestions(String search, List<String> questions) {
    return questions
        .where(
          (question) => question.toLowerCase().contains(search.toLowerCase()),
        )
        .toList();
  }
}
