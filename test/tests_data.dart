import 'package:interview_master/data/enums/difficulty.dart';
import 'package:interview_master/data/enums/direction.dart';
import 'package:interview_master/data/enums/language.dart';
import 'package:interview_master/data/enums/task_type.dart';
import 'package:interview_master/data/models/interview_data.dart';
import 'package:interview_master/data/models/interview_info.dart';
import 'package:interview_master/data/models/question.dart';
import 'package:interview_master/data/models/task.dart';
import 'package:interview_master/data/models/user_data.dart';

class TestsData {
  static const id = 'testId';
  static const name = 'testName';
  static const email = 'testEmail';
  static const password = 'testPassword';
  static const difficulty = Difficulty.junior;
  static const direction = Direction.flutter;
  static const language = Language.russian;
  static const type = TaskType.score;
  static const question = 'testQuestion';
  static const userAnswer = 'testUserAnswer';
  static const correctAnswer = 'testCorrectAnswer';
  static const score = 10;
  static const durationMs = 100;
  static const emailVerified = true;
  static const emailNotVerified = false;
  static final time = DateTime(2025);

  static final userData = UserData(
    id: id,
    name: name,
    email: email,
    directions: [direction],
  );

  static final interviewData = InterviewData(
    id: id,
    score: score,
    difficulty: difficulty,
    direction: direction,
    language: language,
    durationMs: durationMs,
    date: time,
    questions: [questionData],
  );

  static final questionData = Question(
    id: id,
    score: score,
    question: question,
    userAnswer: userAnswer,
    correctAnswer: correctAnswer,
  );

  static final task = Task(
    id: id,
    targetValue: score,
    type: type,
    direction: direction,
    createdAt: time,
  );

  static const interviewInfo = InterviewInfo(
    direction: direction,
    difficulty: difficulty,
    language: language,
  );
}
