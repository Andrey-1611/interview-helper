import 'package:interview_master/data/models/interview/interview_data.dart';
import 'package:interview_master/data/models/interview/question.dart';
import 'package:interview_master/data/models/interview/user_input.dart';
import 'package:interview_master/data/models/user/my_user.dart';
import 'package:interview_master/data/models/user/user_data.dart';

class TestsData {
  static const id = 'testId';
  static const name = 'testName';
  static const email = 'testEmail';
  static const password = 'testPassword';
  static const difficulty = 'testDifficulty';
  static const direction = 'testDirection';
  static const question = 'testQuestion';
  static const userAnswer = 'testUserAnswer';
  static const correctAnswer = 'testCorrectAnswer';
  static const score = 0;
  static const emailVerified = true;
  static const emailNotVerified = false;

  static final user = MyUser(email: email, name: name, id: id);
  static final userData = UserData(name: name, id: id, interviews: []);

  static final interviewData = InterviewData(
    id: TestsData.id,
    score: 5,
    difficulty: TestsData.difficulty,
    direction: TestsData.direction,
    date: DateTime.now(),
    questions: [
      Question(
        score: 5,
        question: TestsData.question,
        userAnswer: TestsData.userAnswer,
        correctAnswer: TestsData.correctAnswer,
      ),
    ],
  );

  static final questionData = Question(
    score: score,
    question: question,
    userAnswer: userAnswer,
    correctAnswer: correctAnswer,
  );

  static final userInput = UserInput(question: question, answer: userAnswer);
}
