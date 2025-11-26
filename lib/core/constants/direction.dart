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

import 'interviews_data.dart';

class Direction {
  final String direction;

  Direction({required this.direction});

  List<String> get questions => switch (direction) {
    InterviewsData.flutter => InterviewsData.allFQuestions,
    InterviewsData.kotlin => InterviewsData.allKotlinQuestions,
    InterviewsData.swift => InterviewsData.allSwiftQuestions,
    InterviewsData.javascript => InterviewsData.allJavaScriptQuestions,
    InterviewsData.python => InterviewsData.allPythonQuestions,
    InterviewsData.cPlusPlus => InterviewsData.allCPlusPlusQuestions,
    InterviewsData.java => InterviewsData.allJavaQuestions,
    InterviewsData.go => InterviewsData.allGoQuestions,
    InterviewsData.git => InterviewsData.allGitQuestions,
    InterviewsData.sql => InterviewsData.allSqlQuestions,
    InterviewsData.typescript => InterviewsData.allTypeScriptQuestions,
    InterviewsData.rust => InterviewsData.allRustQuestions,
    InterviewsData.devops => InterviewsData.allDevOpsQuestions,
    InterviewsData.php => InterviewsData.allPhpQuestions,
    _ => [],
  };

  List<String> get juniorQuestions => switch (direction) {
    InterviewsData.flutter => FlutterQuestions.junior,
    InterviewsData.kotlin => KotlinQuestions.junior,
    InterviewsData.swift => SwiftQuestions.junior,
    InterviewsData.javascript => JavascriptQuestions.junior,
    InterviewsData.python => PythonQuestions.junior,
    InterviewsData.cPlusPlus => CPlusPlusQuestions.junior,
    InterviewsData.java => JavaQuestions.junior,
    InterviewsData.go => GoQuestions.junior,
    InterviewsData.git => GitQuestions.junior,
    InterviewsData.sql => SQLQuestions.junior,
    InterviewsData.typescript => TypescriptQuestions.junior,
    InterviewsData.rust => RustQuestions.junior,
    InterviewsData.devops => DevopsQuestions.junior,
    InterviewsData.php => PhpQuestions.junior,
    _ => [],
  };

  List<String> get middleQuestions => switch (direction) {
    InterviewsData.flutter => FlutterQuestions.middle,
    InterviewsData.kotlin => KotlinQuestions.middle,
    InterviewsData.swift => SwiftQuestions.middle,
    InterviewsData.javascript => JavascriptQuestions.middle,
    InterviewsData.python => PythonQuestions.middle,
    InterviewsData.cPlusPlus => CPlusPlusQuestions.middle,
    InterviewsData.java => JavaQuestions.middle,
    InterviewsData.go => GoQuestions.middle,
    InterviewsData.git => GitQuestions.middle,
    InterviewsData.sql => SQLQuestions.middle,
    InterviewsData.typescript => TypescriptQuestions.middle,
    InterviewsData.rust => RustQuestions.middle,
    InterviewsData.devops => DevopsQuestions.middle,
    InterviewsData.php => PhpQuestions.middle,
    _ => [],
  };

  List<String> get seniorQuestions => switch (direction) {
    InterviewsData.flutter => FlutterQuestions.senior,
    InterviewsData.kotlin => KotlinQuestions.senior,
    InterviewsData.swift => SwiftQuestions.senior,
    InterviewsData.javascript => JavascriptQuestions.senior,
    InterviewsData.python => PythonQuestions.senior,
    InterviewsData.cPlusPlus => CPlusPlusQuestions.senior,
    InterviewsData.java => JavaQuestions.senior,
    InterviewsData.go => GoQuestions.senior,
    InterviewsData.git => GitQuestions.senior,
    InterviewsData.sql => SQLQuestions.senior,
    InterviewsData.typescript => TypescriptQuestions.senior,
    InterviewsData.rust => RustQuestions.senior,
    InterviewsData.devops => DevopsQuestions.senior,
    InterviewsData.php => PhpQuestions.senior,
    _ => [],
  };

  static List<String> searchQuestions(String text, List<String> questions) {
    return questions
        .where(
          (question) => question.toLowerCase().contains(text.toLowerCase()),
        )
        .toList();
  }
}
