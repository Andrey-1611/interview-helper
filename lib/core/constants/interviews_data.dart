import 'package:interview_master/core/constants/questions/c++_questions.dart';
import 'package:interview_master/core/constants/questions/devops_questions.dart';
import 'package:interview_master/core/constants/questions/flutter_questions.dart';
import 'package:interview_master/core/constants/questions/git_questions.dart';
import 'package:interview_master/core/constants/questions/go_questions.dart';
import 'package:interview_master/core/constants/questions/java_questions.dart';
import 'package:interview_master/core/constants/questions/javascript_questions.dart';
import 'package:interview_master/core/constants/questions/kotlin_questions.dart';
import 'package:interview_master/core/constants/questions/php_questions.dart';
import 'package:interview_master/core/constants/questions/python_questions.dart';
import 'package:interview_master/core/constants/questions/rust_questions.dart';
import 'package:interview_master/core/constants/questions/sql_questions.dart';
import 'package:interview_master/core/constants/questions/swift_questions.dart';
import 'package:interview_master/core/constants/questions/typescript_questions.dart';

class InterviewsData {
  static const flutter = 'Flutter';
  static const kotlin = 'Kotlin';
  static const swift = 'Swift';
  static const javascript = 'JavaScript';
  static const python = 'Python';
  static const cPlusPlus = 'C++';
  static const java = 'Java';
  static const go = 'Go';
  static const git = 'Git';
  static const sql = 'Sql';
  static const typescript = 'Typescript';
  static const rust = 'Rust';
  static const devops = 'Devops';
  static const php = 'Php';

  static const junior = 'junior';
  static const middle = 'middle';
  static const senior = 'senior';

  static const List<String> directions = [
    flutter,
    kotlin,
    swift,
    javascript,
    python,
    cPlusPlus,
    java,
    go,
    git,
    sql,
    typescript,
    rust,
    devops,
    php,
  ];

  static const List<String> difficulties = [junior, middle, senior];

  static const firstNew = 'Новые';
  static const firstOld = 'Старые';
  static const firstBest = 'Лучшие';
  static const firstWorst = 'Худшие';

  static const List<String> interviewsSorts = [
    firstNew,
    firstOld,
    firstBest,
    firstWorst,
  ];

  static const firstTotalScore = 'Опыт';
  static const firstTotalInterviews = 'Собеседования';
  static const firstAverageScore = 'Средний результат';

  static const List<String> usersSorts = [
    firstTotalScore,
    firstTotalInterviews,
    firstAverageScore,
  ];

  static const interviews = 'Cобеседования';
  static const time = 'Время';
  static const score = 'Опыт';

  static const types = [interviews, time, score];

  static const tasksSorts = [firstNew, firstOld];

  static const String pending = 'ожидание';
  static const String accepted = 'принято';
  static const String rejected = 'отклонено';

  static const statuses = [pending, accepted, rejected];

  static const allFQuestions = [
    ...FlutterQuestions.junior,
    ...FlutterQuestions.middle,
    ...FlutterQuestions.senior,
  ];

  static const allKotlinQuestions = [
    ...KotlinQuestions.junior,
    ...KotlinQuestions.middle,
    ...KotlinQuestions.senior,
  ];

  static const allSwiftQuestions = [
    ...SwiftQuestions.junior,
    ...SwiftQuestions.middle,
    ...SwiftQuestions.senior,
  ];

  static const allJavaScriptQuestions = [
    ...JavascriptQuestions.junior,
    ...JavascriptQuestions.middle,
    ...JavascriptQuestions.senior,
  ];

  static const allPythonQuestions = [
    ...PythonQuestions.junior,
    ...PythonQuestions.middle,
    ...PythonQuestions.senior,
  ];

  static const allCPlusPlusQuestions = [
    ...CPlusPlusQuestions.junior,
    ...CPlusPlusQuestions.middle,
    ...CPlusPlusQuestions.senior,
  ];

  static const allJavaQuestions = [
    ...JavaQuestions.junior,
    ...JavaQuestions.middle,
    ...JavaQuestions.senior,
  ];

  static const allGoQuestions = [
    ...GoQuestions.junior,
    ...GoQuestions.middle,
    ...GoQuestions.senior,
  ];

  static const allGitQuestions = [
    ...GitQuestions.junior,
    ...GitQuestions.middle,
    ...GitQuestions.senior,
  ];

  static const allSqlQuestions = [
    ...SQLQuestions.junior,
    ...SQLQuestions.middle,
    ...SQLQuestions.senior,
  ];

  static const allTypeScriptQuestions = [
    ...TypescriptQuestions.junior,
    ...TypescriptQuestions.middle,
    ...TypescriptQuestions.senior,
  ];

  static const allRustQuestions = [
    ...RustQuestions.junior,
    ...RustQuestions.middle,
    ...RustQuestions.senior,
  ];

  static const allDevOpsQuestions = [
    ...DevopsQuestions.junior,
    ...DevopsQuestions.middle,
    ...DevopsQuestions.senior,
  ];

  static const allPhpQuestions = [
    ...PhpQuestions.junior,
    ...PhpQuestions.middle,
    ...PhpQuestions.senior,
  ];

  static const allQuestions = [
    ...allFQuestions,
    ...allKotlinQuestions,
    ...allSwiftQuestions,
    ...allJavaScriptQuestions,
    ...allPythonQuestions,
    ...allCPlusPlusQuestions,
    ...allJavaQuestions,
    ...allGoQuestions,
    ...allGitQuestions,
    ...allSqlQuestions,
    ...allTypeScriptQuestions,
    ...allRustQuestions,
    ...allDevOpsQuestions,
    ...allPhpQuestions,
  ];
}
