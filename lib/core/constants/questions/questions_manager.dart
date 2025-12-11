import '../../../data/enums/direction.dart';
import 'base_direction.dart';
import 'directions/c_plus_plus_direction.dart';
import 'directions/devops_direction.dart';
import 'directions/flutter_direction.dart';
import 'directions/git_direction.dart';
import 'directions/java_direction.dart';
import 'directions/javascript_direction.dart';
import 'directions/kotlin_direction.dart';
import 'directions/php_direction.dart';
import 'directions/python_direction.dart';
import 'directions/rust_direction.dart';
import 'directions/sql_direction.dart';
import 'directions/swift_direction.dart';
import 'directions/typescript_direction.dart';
import 'directions/go_direction.dart';

abstract class QuestionsManager {
  static BaseDirection direction(Direction direction) {
    return switch (direction) {
      Direction.git => GitDirection(),
      Direction.go => GoDirection(),
      Direction.flutter => FlutterDirection(),
      Direction.cpp => SPlusPlusDirection(),
      Direction.java => JavaDirection(),
      Direction.python => PythonDirection(),
      Direction.javascript => JavascriptDirection(),
      Direction.kotlin => KotlinDirection(),
      Direction.swift => SwiftDirection(),
      Direction.typescript => TypescriptDirection(),
      Direction.rust => RustDirection(),
      Direction.devops => DevopsDirection(),
      Direction.sql => SqlDirection(),
      Direction.php => PhpDirection(),
    };
  }
}
