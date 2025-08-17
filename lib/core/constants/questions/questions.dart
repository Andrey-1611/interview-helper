import 'dart:math';
import 'package:interview_master/core/constants/directions.dart';
import 'package:interview_master/core/constants/questions/c++_questions.dart';
import 'package:interview_master/core/constants/questions/javascript_questions.dart';
import 'package:interview_master/core/constants/questions/python_questions.dart';

import 'flutter_questions.dart';
import 'kotlin_questions.dart';
import 'swift_questions.dart';

class Questions {
  final FlutterQuestions flutter;
  final KotlinQuestions kotlin;
  final SwiftQuestions swift;
  final JavascriptQuestions javascript;
  final PythonQuestions python;
  final CPlusPlusQuestions cPlusPlus;

  Questions({
    required this.kotlin,
    required this.flutter,
    required this.swift,
    required this.cPlusPlus,
    required this.javascript,
    required this.python,
  });


}

