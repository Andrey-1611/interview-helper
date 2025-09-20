import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:interview_master/core/constants/data.dart';
import 'package:interview_master/core/constants/questions/c++_questions.dart';
import 'package:interview_master/core/constants/questions/flutter_questions.dart';
import 'package:interview_master/core/constants/questions/javascript_questions.dart';
import 'package:interview_master/core/constants/questions/kotlin_questions.dart';
import 'package:interview_master/core/constants/questions/python_questions.dart';
import 'package:interview_master/core/constants/questions/swift_questions.dart';
import 'package:interview_master/data/models/interview/user_input.dart';

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
      [InitialData.flutter, InitialData.junior] => FlutterQuestions.junior,
      [InitialData.flutter, InitialData.middle] => FlutterQuestions.middle,
      [InitialData.flutter, InitialData.senior] => FlutterQuestions.senior,

      [InitialData.kotlin, InitialData.junior] => KotlinQuestions.junior,
      [InitialData.kotlin, InitialData.middle] => KotlinQuestions.middle,
      [InitialData.kotlin, InitialData.senior] => KotlinQuestions.senior,

      [InitialData.swift, InitialData.junior] => SwiftQuestions.junior,
      [InitialData.swift, InitialData.middle] => SwiftQuestions.middle,
      [InitialData.swift, InitialData.senior] => SwiftQuestions.senior,

      [InitialData.javascript, InitialData.junior] =>
        JavascriptQuestions.junior,
      [InitialData.javascript, InitialData.middle] =>
        JavascriptQuestions.middle,
      [InitialData.javascript, InitialData.senior] =>
        JavascriptQuestions.senior,

      [InitialData.python, InitialData.junior] => PythonQuestions.junior,
      [InitialData.python, InitialData.middle] => PythonQuestions.middle,
      [InitialData.python, InitialData.senior] => PythonQuestions.senior,

      [InitialData.cPlusPlus, InitialData.junior] => CPlusPlusQuestions.junior,
      [InitialData.cPlusPlus, InitialData.middle] => CPlusPlusQuestions.middle,
      [InitialData.cPlusPlus, InitialData.senior] => CPlusPlusQuestions.senior,

      _ => [],
    };

    final myQuestions = List<String>.from(questions)..shuffle(random);
    return myQuestions.take(10).toList();
  }

  static String textInFilter(String direction, String difficulty, String sort) {
    return [
      if (direction.isNotEmpty) direction,
      if (difficulty.isNotEmpty) difficulty,
      if (sort.isNotEmpty) sort,
    ].join(', ');
  }
}
