import '../models/gemini_response.dart';
import '../models/interview.dart';

abstract interface class InterviewRepository {
  Interview createInterview(List<GeminiResponses> remoteDataSource, int difficulty);
}