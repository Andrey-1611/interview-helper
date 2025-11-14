import 'package:equatable/equatable.dart';

class UserInput extends Equatable {
  final String question;
  final String answer;

  const UserInput({required this.question, required this.answer});

  @override
  List<Object?> get props => [question, answer];

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
