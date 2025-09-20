import 'package:equatable/equatable.dart';
import '../../../../../core/constants/main_prompt.dart';

class UserInput extends Equatable {
  final String question;
  final String answer;

  const UserInput({required this.question, required this.answer});

  @override
  List<Object?> get props => [question, answer];

  static String createPrompt(List<UserInput> userInputs) {
    final prompt = userInputs
        .map((e) => 'Вопрос: ${_clear(e.question)}\nОтвет: ${_clear(e.answer)}')
        .join('\n\n');
    return '${MainPrompt.mainPrompt}\n\nВопросы:\n$prompt';
  }

  static String _clear(String text) {
    return text.replaceAll("'", '').replaceAll('"', '');
  }

  static List<UserInput> fromInput(
    List<String> questions,
    List<String> answers,
  ) {
    return List.generate(
      10,
      (index) => UserInput(question: questions[index], answer: answers[index]),
    );
  }
}
