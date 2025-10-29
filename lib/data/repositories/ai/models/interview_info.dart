import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:interview_master/core/constants/data.dart';
import 'package:interview_master/core/constants/questions/c++_questions.dart';
import 'package:interview_master/core/constants/questions/flutter_questions.dart';
import 'package:interview_master/core/constants/questions/javascript_questions.dart';
import 'package:interview_master/core/constants/questions/kotlin_questions.dart';
import 'package:interview_master/core/constants/questions/python_questions.dart';
import 'package:interview_master/core/constants/questions/swift_questions.dart';
import 'package:interview_master/data/repositories/ai/models/user_input.dart';
import '../../../../core/constants/main_prompt.dart';
import '../../../../core/constants/questions/devops_questions.dart';
import '../../../../core/constants/questions/git_questions.dart';
import '../../../../core/constants/questions/go_questions.dart';
import '../../../../core/constants/questions/java_questions.dart';
import '../../../../core/constants/questions/php_questions.dart';
import '../../../../core/constants/questions/rust_questions.dart';
import '../../../../core/constants/questions/sql_questions.dart';
import '../../../../core/constants/questions/typescript_questions.dart';

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

      [InitialData.java, InitialData.junior] => JavaQuestions.junior,
      [InitialData.java, InitialData.middle] => JavaQuestions.middle,
      [InitialData.java, InitialData.senior] => JavaQuestions.senior,

      [InitialData.go, InitialData.junior] => GoQuestions.junior,
      [InitialData.go, InitialData.middle] => GoQuestions.middle,
      [InitialData.go, InitialData.senior] => GoQuestions.senior,

      [InitialData.git, InitialData.junior] => GitQuestions.junior,
      [InitialData.git, InitialData.middle] => GitQuestions.middle,
      [InitialData.git, InitialData.senior] => GitQuestions.senior,

      [InitialData.sql, InitialData.junior] => SQLQuestions.junior,
      [InitialData.sql, InitialData.middle] => SQLQuestions.middle,
      [InitialData.sql, InitialData.senior] => SQLQuestions.senior,

      [InitialData.typescript, InitialData.junior] =>
        TypescriptQuestions.junior,
      [InitialData.typescript, InitialData.middle] =>
        TypescriptQuestions.middle,
      [InitialData.typescript, InitialData.senior] =>
        TypescriptQuestions.senior,

      [InitialData.rust, InitialData.junior] => RustQuestions.junior,
      [InitialData.rust, InitialData.middle] => RustQuestions.middle,
      [InitialData.rust, InitialData.senior] => RustQuestions.senior,

      [InitialData.devops, InitialData.junior] => DevopsQuestions.junior,
      [InitialData.devops, InitialData.middle] => DevopsQuestions.middle,
      [InitialData.devops, InitialData.senior] => DevopsQuestions.senior,

      [InitialData.php, InitialData.junior] => PhpQuestions.junior,
      [InitialData.php, InitialData.middle] => PhpQuestions.middle,
      [InitialData.php, InitialData.senior] => PhpQuestions.senior,

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

  static String createPrompt(InterviewInfo interviewInfo) {
    final prompt = interviewInfo.userInputs
        .map((e) => 'Вопрос: ${e.question}\nОтвет: ${e.answer}')
        .join('\n\n');
    return '${MainPrompt.mainPrompt}\n\nВопросы:\n$prompt';
  }
}
