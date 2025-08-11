class UserInput {
  final String question;
  final String answer;

  UserInput({required this.question, required this.answer});

  static String _clear(String text) {
    return text.replaceAll("'", '').replaceAll('"', '');
  }

  static String createPrompt(List<UserInput> userInputs) {
    return userInputs
        .map((e) => 'Вопрос: ${_clear(e.question)}\nОтвет: ${_clear(e.answer)}')
        .join('\n\n');
  }
}
