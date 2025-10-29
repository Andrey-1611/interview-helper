part of 'speech_cubit.dart';

class SpeechState extends Equatable {
  final bool isListening;
  final String text;

  const SpeechState({this.isListening = false, this.text = ''});

  @override
  List<Object?> get props => [isListening, text];

  SpeechState copyWith({String? text, bool? isListening}) {
    return SpeechState(
      text: text ?? this.text,
      isListening: isListening ?? this.isListening,
    );
  }
}
