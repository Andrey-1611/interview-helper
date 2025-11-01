part of 'speech_cubit.dart';

class SpeechState extends Equatable {
  final bool isListening;
  final bool needSpeak;
  final String text;

  const SpeechState({
    this.isListening = false,
    this.needSpeak = true,
    this.text = '',
  });

  @override
  List<Object?> get props => [isListening, text, needSpeak];

  SpeechState copyWith({String? text, bool? isListening, bool? needSpeak}) {
    return SpeechState(
      text: text ?? this.text,
      isListening: isListening ?? this.isListening,
      needSpeak: needSpeak ?? this.needSpeak,
    );
  }
}
