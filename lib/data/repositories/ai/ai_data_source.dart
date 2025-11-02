import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:interview_master/data/repositories/ai/models/interview_info.dart';
import '../../../core/constants/main_prompt.dart';
import '../../models/question.dart';
import 'ai_repository.dart';

@LazySingleton(as: AIRepository)
class AIDataSource implements AIRepository {
  final Dio _dio;

  static const _baseUrl = 'https://api.gen-api.ru/api/v1';
  static final _apiKey = dotenv.env['API_KEY'];

  AIDataSource(this._dio) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };
  }

  @override
  Future<List<Question>> checkAnswers(InterviewInfo interviewInfo) async {
    final questionsData = interviewInfo.userInputs
        .map((e) => 'Вопрос: ${e.question}\nОтвет: ${e.answer}')
        .join('\n\n');
    final prompt = '${MainPrompt.mainPrompt}\n\nВопросы:\n$questionsData';

    final response = await _dio.post(
      '/networks/gpt-4-1',
      data: {
        'model': 'gpt-4.1-nano',
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'is_sync': true,
        'temperature': 0.2,
      },
    );
    final content =
        response.data['response'][0]['message']['content'] as String;
    final parsedJson = jsonDecode(content) as Map<String, dynamic>;
    final evaluations = parsedJson['evaluations'] as List<dynamic>;

    return evaluations.map((e) => Question.fromAI(e)).toList();
  }
}
