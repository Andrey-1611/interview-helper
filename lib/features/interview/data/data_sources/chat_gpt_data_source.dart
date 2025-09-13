import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:interview_master/core/secrets/api_key.dart';
import '../../../../core/constants/main_prompt.dart';
import '../models/question.dart';
import '../models/user_input.dart';

class ChatGPTDataSource {
  final Dio _dio;

  ChatGPTDataSource(this._dio) {
    _dio.options.baseUrl = CHAT_GPT_BASE_URL;
    _dio.options.headers = {
      'Authorization': 'Bearer $CHAT_GPT_API_KEY',
      'Content-Type': 'application/json',
    };
  }

  Future<List<Question>> checkAnswers(List<UserInput> userInputs) async {
    try {
      final prompt =
          '${MainPrompt.mainPrompt}\n\nВопросы:\n${UserInput.createPrompt(
          userInputs)}';

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
