import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:interview_master/core/constants/interviews_data.dart';
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
  final String? id;

  const InterviewInfo({
    required this.userInputs,
    required this.direction,
    required this.difficulty,
    this.id,
  });

  @override
  List<Object?> get props => [direction, difficulty, userInputs];

  static List<String> selectQuestions(InterviewInfo info) {
    final random = Random();
    final questions = switch ([info.direction, info.difficulty]) {
      [InterviewsData.flutter, InterviewsData.junior] => FlutterQuestions.junior,
      [InterviewsData.flutter, InterviewsData.middle] => FlutterQuestions.middle,
      [InterviewsData.flutter, InterviewsData.senior] => FlutterQuestions.senior,

      [InterviewsData.kotlin, InterviewsData.junior] => KotlinQuestions.junior,
      [InterviewsData.kotlin, InterviewsData.middle] => KotlinQuestions.middle,
      [InterviewsData.kotlin, InterviewsData.senior] => KotlinQuestions.senior,

      [InterviewsData.swift, InterviewsData.junior] => SwiftQuestions.junior,
      [InterviewsData.swift, InterviewsData.middle] => SwiftQuestions.middle,
      [InterviewsData.swift, InterviewsData.senior] => SwiftQuestions.senior,

      [InterviewsData.javascript, InterviewsData.junior] =>
        JavascriptQuestions.junior,
      [InterviewsData.javascript, InterviewsData.middle] =>
        JavascriptQuestions.middle,
      [InterviewsData.javascript, InterviewsData.senior] =>
        JavascriptQuestions.senior,

      [InterviewsData.python, InterviewsData.junior] => PythonQuestions.junior,
      [InterviewsData.python, InterviewsData.middle] => PythonQuestions.middle,
      [InterviewsData.python, InterviewsData.senior] => PythonQuestions.senior,

      [InterviewsData.cPlusPlus, InterviewsData.junior] => CPlusPlusQuestions.junior,
      [InterviewsData.cPlusPlus, InterviewsData.middle] => CPlusPlusQuestions.middle,
      [InterviewsData.cPlusPlus, InterviewsData.senior] => CPlusPlusQuestions.senior,

      [InterviewsData.java, InterviewsData.junior] => JavaQuestions.junior,
      [InterviewsData.java, InterviewsData.middle] => JavaQuestions.middle,
      [InterviewsData.java, InterviewsData.senior] => JavaQuestions.senior,

      [InterviewsData.go, InterviewsData.junior] => GoQuestions.junior,
      [InterviewsData.go, InterviewsData.middle] => GoQuestions.middle,
      [InterviewsData.go, InterviewsData.senior] => GoQuestions.senior,

      [InterviewsData.git, InterviewsData.junior] => GitQuestions.junior,
      [InterviewsData.git, InterviewsData.middle] => GitQuestions.middle,
      [InterviewsData.git, InterviewsData.senior] => GitQuestions.senior,

      [InterviewsData.sql, InterviewsData.junior] => SQLQuestions.junior,
      [InterviewsData.sql, InterviewsData.middle] => SQLQuestions.middle,
      [InterviewsData.sql, InterviewsData.senior] => SQLQuestions.senior,

      [InterviewsData.typescript, InterviewsData.junior] =>
        TypescriptQuestions.junior,
      [InterviewsData.typescript, InterviewsData.middle] =>
        TypescriptQuestions.middle,
      [InterviewsData.typescript, InterviewsData.senior] =>
        TypescriptQuestions.senior,

      [InterviewsData.rust, InterviewsData.junior] => RustQuestions.junior,
      [InterviewsData.rust, InterviewsData.middle] => RustQuestions.middle,
      [InterviewsData.rust, InterviewsData.senior] => RustQuestions.senior,

      [InterviewsData.devops, InterviewsData.junior] => DevopsQuestions.junior,
      [InterviewsData.devops, InterviewsData.middle] => DevopsQuestions.middle,
      [InterviewsData.devops, InterviewsData.senior] => DevopsQuestions.senior,

      [InterviewsData.php, InterviewsData.junior] => PhpQuestions.junior,
      [InterviewsData.php, InterviewsData.middle] => PhpQuestions.middle,
      [InterviewsData.php, InterviewsData.senior] => PhpQuestions.senior,

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
