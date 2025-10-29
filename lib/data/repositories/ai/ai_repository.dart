import 'package:interview_master/data/repositories/ai/models/interview_info.dart';
import '../../models/question.dart';

abstract interface class AIRepository {
  Future<List<Question>> checkAnswers(InterviewInfo interviewInfo);
}