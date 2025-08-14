import 'dart:convert';
import 'dart:developer';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:interview_master/core/constants/main_prompt.dart';
import 'package:interview_master/core/helpers/toast_helpers/toast_helper.dart';
import 'package:interview_master/features/interview/data/models/question.dart';
import '../models/user_input.dart';

class GeminiDataSource {
  final Gemini _gemini;

  const GeminiDataSource(this._gemini);

  Future<List<Question>> checkAnswers(List<UserInput> userInputs) async {
    try {
      final prompt =
          '${MainPrompt.mainPrompt}\n\nВопросы:\n${UserInput.createPrompt(userInputs)}';

      final response = await _gemini.prompt(parts: [TextPart(prompt)]);
      final parsedJson = jsonDecode(response!.output!) as Map<String, dynamic>;

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
