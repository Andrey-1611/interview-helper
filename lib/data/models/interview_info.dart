import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:interview_master/core/constants/questions/c++_questions.dart';
import 'package:interview_master/core/constants/questions/flutter_questions.dart';
import 'package:interview_master/core/constants/questions/javascript_questions.dart';
import 'package:interview_master/core/constants/questions/kotlin_questions.dart';
import 'package:interview_master/core/constants/questions/python_questions.dart';
import 'package:interview_master/core/constants/questions/swift_questions.dart';
import 'package:interview_master/data/models/user_input.dart';

class InterviewInfo extends Equatable {
  final String direction;
  final String difficulty;
  final List<UserInput> userInputs;

  const InterviewInfo({
    required this.userInputs,
    required this.direction,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [direction, difficulty, userInputs];

  static List<String> selectQuestions(InterviewInfo info) {
    final random = Random();

    final questions = switch ([info.direction, info.difficulty]) {
      ['Flutter', 'junior'] => FlutterQuestions.junior,
      ['Flutter', 'middle'] => FlutterQuestions.middle,
      ['Flutter', 'senior'] => FlutterQuestions.senior,

      ['Kotlin', 'junior'] => KotlinQuestions.junior,
      ['Kotlin', 'middle'] => KotlinQuestions.middle,
      ['Kotlin', 'senior'] => KotlinQuestions.senior,

      ['Swift', 'junior'] => SwiftQuestions.junior,
      ['Swift', 'middle'] => SwiftQuestions.middle,
      ['Swift', 'senior'] => SwiftQuestions.senior,

      ['Javascript', 'junior'] => JavascriptQuestions.junior,
      ['Javascript', 'middle'] => JavascriptQuestions.middle,
      ['Javascript', 'senior'] => JavascriptQuestions.senior,

      ['Python', 'junior'] => PythonQuestions.junior,
      ['Python', 'middle'] => PythonQuestions.middle,
      ['Python', 'senior'] => PythonQuestions.senior,

      ['C++', 'junior'] => CPlusPlusQuestions.junior,
      ['C++', 'middle'] => CPlusPlusQuestions.middle,
      ['C++', 'senior'] => CPlusPlusQuestions.senior,

      _ => [],
    };

    final myQuestions = List<String>.from(questions)..shuffle(random);
    return myQuestions.take(10).toList();
  }

  static String textInFilter(InterviewInfo info, String sort) {
    return [
      if (info.direction.isNotEmpty) info.direction,
      if (info.difficulty.isNotEmpty) info.difficulty,
      if (sort.isNotEmpty) sort,
    ].join(', ');
  }
}
