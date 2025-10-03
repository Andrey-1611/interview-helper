import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:interview_master/core/secrets/api_key.dart';
import 'package:interview_master/data/models/interview/interview_info.dart';
import '../../core/constants/main_prompt.dart';
import '../models/interview/question.dart';
import '../repositories/ai_repository.dart';

@LazySingleton(as: AIRepository)
class ChatGPTDataSource implements AIRepository {
  final Dio _dio;

  static const _baseUrl = 'https://api.gen-api.ru/api/v1';

  ChatGPTDataSource(this._dio) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer $CHAT_GPT_API_KEY',
      'Content-Type': 'application/json',
    };
  }

  @override
  Future<List<Question>> checkAnswers(InterviewInfo interviewInfo) async {
    try {
      final prompt =
          '${MainPrompt.mainPrompt}\n\nВопросы:\n${InterviewInfo.createPrompt(interviewInfo)}';

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
      final evaluations = parsedJson['evaluations'] as List;

      return evaluations
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
