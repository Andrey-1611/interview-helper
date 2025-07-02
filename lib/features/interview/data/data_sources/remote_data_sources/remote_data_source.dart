import 'dart:convert';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../../models/gemini_response.dart';
import '../../models/user_input.dart';
import 'remote_data_source_interface.dart';

class RemoteDataSource implements RemoteDataSourceInterface {
  final Gemini gemini;

  const RemoteDataSource({required this.gemini});


  @override
  Future<List<GeminiResponses>> checkAnswers(List<UserInput> userInputs) async {
    const mainPrompt = '''
      Ты - JSON-генератор. Верни ТОЛЬКО валидный JSON без комментариев.
      Шаблон:
        {
          "evaluations": [
            {
              "question": "вопрос",
              "user_answer": "ответ",
              "score": точная сумма баллов по критериям (0-100) не круглое число,
              "correct_answer": "правильный ответ"
            }
          ] 
        }
        
        Критерии оценки:
        - Идеально точный ответ: 86-100 баллов
        - Правильный в целом ответ: 65-85 
        - Средний ответ: 45-64
        - Слабый, но частично верный: 25-44
        - Почти полностью неверный: 1-24
        - Пустой или полностью неверный: 0
        - Запрещены числа, оканчивающиеся на 0 или 5 (кроме 100)
    ''';

    final promptFromUserInput = userInputs
        .map((e) => 'Вопрос: ${e.question}\nОтвет: ${e.answer}')
        .join('\n\n');
    final prompt = '$mainPrompt\n\nВопросы:\n$promptFromUserInput';

    final response = await gemini.prompt(parts: [TextPart(prompt)]);
    final content = response?.output ?? '';

    final jsonString =
        content.replaceFirst('```json', '').replaceFirst('```', '').trim();

    final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;
    final evaluations = parsedJson['evaluations'] as List;

    return evaluations
        .map((e) => GeminiResponses.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
