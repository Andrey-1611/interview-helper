import 'package:interview_master/data/models/interview/interview_info.dart';
import '../models/interview/question.dart';

abstract interface class AIRepository {
  Future<List<Question>> checkAnswers(InterviewInfo interviewInfo);
}